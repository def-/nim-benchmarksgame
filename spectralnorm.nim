{.experimental.}

import os, math, strutils, threadpool

proc A(i, j: int): float {.inline.} =
  return float(((i+j) * (i+j+1) div 2 + i + 1))

proc dot(v: auto, u: auto): float =
  for i, vi in v: result += vi * u[i]

proc column(v: auto, i: int): float =   #XXX SSE/AVX vectorize?
  for j, vj in v: result += vj / A(i, j)

proc mult_Av(v: auto, o: var auto) =
  parallel:
    for i in 0 ..< len(o): o[i] = spawn column(v, i)

proc columnT(v: auto, i: int): float =  #XXX SSE/AVX vectorize?
  for j, vj in v: result += vj / A(j, i)

proc mult_Atv(v: auto, o: var auto) =
  parallel:
    for i in 0 ..< len(o): o[i] = spawn columnT(v, i)

proc mult_AtAv(v: auto, tmp: var auto, o: var auto) =
  mult_Av(v, tmp)
  mult_Atv(tmp, o)

proc main() =
  var n = parseInt(commandLineParams()[0])
  if n <= 0: n = 2000
  var u = newSeq[float](n)
  var v = newSeq[float](n)
  var tmp = newSeq[float](n)
  for i in 0 ..< n: u[i] = 1
  for i in 0 ..< 10:
     mult_AtAv(u, tmp, v)
     mult_AtAv(v, tmp, u)
  echo formatFloat(sqrt(dot(u, v) / dot(v, v)), ffDecimal, 9)

main()
