{.experimental.}

import os, strutils, threadpool

type float2 = array[2, float] #XXX replace with SSE/AVX things
proc `*`(x, y: float2): float2 {.inline.} =
  result[0] = x[0] * y[0]
  result[1] = x[1] * y[1]
proc `+`(x, y: float2): float2 {.inline.} =
  result[0] = x[0] + y[0]
  result[1] = x[1] + y[1]
proc `-`(x, y: float2): float2 {.inline.} =
  result[0] = x[0] - y[0]
  result[1] = x[1] - y[1]
type float2x4 = array[4, float2]

proc allOut(m2: float2x4): bool {.inline.} =  #XXX SSE/AVX "min"
  proc b(i, j: int): int {.inline.} =         # NOTE: NAN requires not <= vs >
    result = if not (m2[i][j] <= 4.0): 1 else: 0
  result = b(0,0)+b(0,1)+b(1,0)+b(1,1)+b(2,0)+b(2,1)+b(3,0)+b(3,1) == 8

proc pixel(m2: float2x4): uint8 {.inline.} =
  proc b(i, j, bit: int): uint8 {.inline.} =  # NOTE: NAN requires not <= vs >
    result = (if not (m2[i][j] <= 4.0): 0'u8 else: 1'u8) shl bit
  result = b(0,0,7) or b(0,1,6) or b(1,0,5) or b(1,1,4) or
           b(2,0,3) or b(2,1,2) or b(3,0,1) or b(3,1,0)

proc iter(r: var float2x4, i: var float2x4, m2: var float2x4,
          r0: float2x4, i0: float2) {.inline.} =
  for elt in 0..3:
    let r2 = r[elt] * r[elt]
    let i2 = i[elt] * i[elt]
    let ri = r[elt] * i[elt]
    m2[elt] = r2 + i2
    r[elt] = r2 - i2 + r0[elt]
    i[elt] = ri + ri + i0

proc mand8(r0: float2x4, i0: float2): uint8 =
  var r = r0
  var i, m2: float2x4
  for elt in 0..3:
    i[elt] = i0
  for it in 0..7:
    iter(r, i, m2, r0, i0); iter(r, i, m2, r0, i0); iter(r, i, m2, r0, i0)
    iter(r, i, m2, r0, i0); iter(r, i, m2, r0, i0); iter(r, i, m2, r0, i0)
    if allOut(m2): return 0
  iter(r, i, m2, r0, i0); iter(r, i, m2, r0, i0)
  result = pixel(m2)

proc row(bytes: var seq[uint8]; y, rowLen, size: int; cR: seq[float2], cI: seq[float]) =
  var init_i: float2; init_i[0] = cI[y]; init_i[1] = cI[y]
  let b0 = y * rowLen
  var r: float2x4
  for x in countup(0, size - 1, 8):
    let j = x div 2
    r[0] = cR[j+0]; r[1] = cR[j+1]; r[2] = cR[j+2]; r[3] = cR[j+3]
    bytes[b0 + x div 8] = mand8(r, init_i)

proc main() =
  let size = (parseInt(commandLineParams()[0]) + 7) and not 7
  let rowLen = size div 8
  let step = 2.0 / float(size)
  var cR = newSeq[float2](size div 2)
  var cI = newSeq[float](size)
  for xy in countup(0, size - 1, 2):
    cR[xy div 2] = [ step * float(xy) - 1.5, step * (float(xy) + 1) - 1.5 ]
  for y in 0 ..< size:
    cI[y] = step * float(y) - 1.0
  var bytes = newSeq[uint8](size * rowLen)
  parallel:
    for y in 0 ..< size:
      spawn row(bytes, y, rowLen, size, cR, cI)
  stdout.write("P4\n$1 $2\n" % [$size, $size])
  discard stdout.writeBuffer(addr bytes[0], size * rowLen)
main()
