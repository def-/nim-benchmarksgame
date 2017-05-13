{.experimental.}

import os, complex, strutils, threadpool

proc inMandelbrot(c: Complex): uint8 {.inline.} =
  var z: Complex = (0.0,0.0)
  for i in 1..50:
    z *= z; z += c
    if z.re * z.re  +  z.im * z.im > 4.0: return 0'u8
  return 1'u8

proc row(bytes: var seq[uint8]; y, rowLen, size: int; cR: seq[float], cI: seq[float]) =
  let b0 = y * rowLen
  var c: Complex = (0.0, cI[y])
  for x in countup(0, size - 1, 8):
    var byte: uint8
    for bit in 0..7:
      c.re = cR[x + bit]
      byte = byte  or  inMandelbrot(c) shl (7 - bit)
    bytes[b0  +  x shr 3] = byte

proc main() =
  let size = (parseInt(commandLineParams()[0]) + 7) and not 7
  let rowLen = size div 8
  let step = 2.0 / float(size)
  var cR = newSeq[float](size)
  var cI = newSeq[float](size)
  for x in 0 ..< size: cR[x] = step * float(x) - 1.5
  for y in 0 ..< size: cI[y] = step * float(y) - 1.0
  var bytes = newSeq[uint8](size * rowLen)
  parallel:
    for y in 0 ..< size:
      spawn row(bytes, y, rowLen, size, cR, cI)
  stdout.write("P4\n$1 $2\n" % [$size, $size])
  discard stdout.writeBuffer(addr bytes[0], size * rowLen)
main()
