# contributed by Charles Blake

import hashes
proc hash*(x: int64): Hash {.inline.} =
  result = Hash(x) * Hash(0x7a48d7c544ffa2af)
import memfiles, tables, sequtils, algorithm, strutils, threadpool

const base4digits = "GATC"

proc buildBase4(): array[256, int] =
  for i,c in base4digits:
    result[int(c)] = i
    result[int(toLowerAscii(c))] = i
const b4 = buildBase4()

proc toBase4(sq: string): int64 =
  for c in sq:
    result = (result shl 2) or b4[int(c)]

proc toStr(b4n: int64, nDig: int): string =
  result = ""
  for shift in countdown(nDig - 1, 0):
    result.add(base4digits[(b4n shr (2 * shift)) and 3])

proc memmem(hay: pointer, nHay: csize, qry: pointer, nQry: csize): pointer{.
            importc: "memmem", header: "<string.h>" .}
proc memchr(hay: pointer, qry: cint, nHay: csize): pointer {.
            importc: "memchr", header: "<string.h>" .}
proc frameFasta(mem: var cstring, i0: var int, i1: var int) =
  let inp = memfiles.open("/dev/stdin")
  mem = cast[cstring](inp.mem)
  let sectn = memmem(mem, inp.size, cstring("\l>THREE"), 7)
  let p = cast[int](sectn) +% 7
  let z = inp.size - (p - cast[int](mem))
  i0 = cast[int](memchr(cast[pointer](p), cint('\l'), z)) -% cast[int](mem)
  i1 = inp.size - 1

iterator fastaAsBase4(mem: cstring, i0: int, i1: int): int =
  for i in i0 .. i1:
    let c = mem[i]
    if c == '>' or c == ';':
      break
    if c != '\l':
      yield b4[int(c)]

proc histo1(ct: ptr CountTable[int64], mem: cstring, i0: int, i1: int, fL: int)=
  var num, nDig: int
  let mask = (1 shl (2 * fL)) - 1
  for digit in fastaAsBase4(mem, i0, i1):
    inc(nDig)
    num = num or digit
    if nDig >= fL:
      ct[].inc(num and mask)
    num = num shl 2

proc histos(fLs: openarray[int]): array[7, CountTable[int64]] =
  var mem: cstring
  var i0, i1: int
  frameFasta(mem, i0, i1)
  for i in 0 .. high(fLs):
    result[i] = initCountTable[int64](initialSize=32)
    spawn histo1(addr result[i], mem, i0, i1, fLs[i])
  sync()

proc histoPr(ct: var CountTable[int64], fL: int) =
  ct.sort()
  var sum = 0
  for k,v in ct: sum += v
  let scale = 100.0 / float(sum)
  for k,v in ct:
    echo toStr(k, fL), " ", formatFloat(scale * float(v), ffDecimal, 3)
  echo ""

let fLs = [ 1, 2, 3, 4, 6, 12, 18 ]
var counts = histos(fLs)
for i in [0, 1]:
  histoPr(counts[i], fLs[i])
for i,sq in ["GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"]:
  echo counts[2+i].getOrDefault(toBase4(sq)), "\t", sq
