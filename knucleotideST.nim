# contributed by Charles Blake

import hashes
proc hash*(x: int64): Hash {.inline.} =
  result = Hash(x) * Hash(0x7a48d7c544ffa2af)
import tables, strutils

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

iterator fastaAsBase4(): int =
  for line in lines(stdin):
    if line[0] == '>' and line.startswith(">THREE "):
      break
  for line in lines(stdin):
    if line[0] == '>' or line[0] == ';':
      break
    for c in line:
      yield b4[int(c)]

proc histos(fLs: openarray[int]): seq[CountTable[int64]] =
  result = @[ ]
  var mask: seq[int] = @[ ]
  for i,fL in fLs:
    result.add(initCountTable[int64](initialSize=32))
    mask.add((1 shl (2 * fL)) - 1)
  var num = 0; var nDig = 0
  for digit in fastaAsBase4():
    inc(nDig)
    num = num or digit
    for i,fL in fLs:
      if nDig >= fL:
        result[i].inc(num and mask[i])
    num = num shl 2

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
