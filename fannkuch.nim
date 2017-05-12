proc initFactorial(n: int): seq[int] =
  result = newSeq[int](n + 1)
  result[0] = 1;
  for i in 1..n:
    result[i] = i * result[i - 1]
const factorial = initFactorial(20) # 21! exceeds 64-bit integer rep

proc rotate*[T](x: var openArray[T]; firstA, middleA, last: int) =
  var first = firstA
  var middle = middleA
  var next = middle
  while first != next:
    swap(x[first], x[next])
    inc(first); inc(next)
    if   next == last: next = middle
    elif first == middle: middle = next

iterator parPerms*[T](s: var openArray[T], b, blkLen, n: int): int {.inline.} =
  ## `parPerms` is for partial/parallel/paritioned permutations. It cycles the
  ## first `n` items of openArray `s[]` through the subset of permutations for
  ## block `b` of length `blkLen`. Yielded value is a 0..<n! enumeration index.
  ## .. code-block::
  ## proc permBlock(b, blkLen, n: int) =
  ##   var s = newSeq[int](n)  # init s[] to something/copy from enclosing scope
  ##   for ix in parPerms(s, b, blkLen, n):
  ##     discard               # do something with s[]
  ## parallel:   #Construct is picky; vars must be in a proc, not global, etc.
  ##   for b in 0 ..< 8:       # E.g., do 11! perms in 8 blocks over threadpool
  ##     spawn permBlock(b, fac(11) div 8, 11)
  var c = newSeq[int](n)
  var ix = b * blkLen
  let i1 = ix + blkLen
  var i0 = ix
  for i in countdown(n - 1, 0):
    let d = i0 div factorial[i]
    i0 = i0 mod factorial[i]
    c[i] = d
  yield 0
  for i in countdown(n - 1, 0):
    rotate(s, 0, c[i], i + 1)
  while true:
    inc(ix)
    yield ix
    if ix == i1:
      break
    var i = 1
    while true:
      let tmp = s[0] # rotate s[] left by 1
      moveMem(addr s[0], addr s[1], i * sizeof(s[0]))
      s[i] = tmp
      inc(c[i])
      if c[i] <= i:
        break
      c[i] = 0
      inc(i)

import os, strutils, math, threadpool #Above iterator should be moved to std lib

proc permBlock(b, blkLen, n: int, maxFlipsRes: ptr int, checksumRes: ptr int) =
  var s, P: array[16, int]  # declared high to share with the nFlips() sub-scope
  for i in 0..< n: s[i] = i

  proc nFlips(): int {.inline.} =
    ## Return number of flips required to flip 0 to the front of the permutation
    copyMem(addr P[0], addr s[0], n * sizeof(s[0]))
    var i = 1
    while true:
      var x = 0 # reverse(P, 0, P[0]) is ~6% slower; not-inline, argCpy
      var y = P[0]
      while x < y:
        swap(P[x], P[y])
        inc(x); dec(y)
      inc(i)
      if P[P[0]] == 0:
        break
    return i

  var checksum, maxFlips: int
  for ix in parPerms(s, b, blkLen, n):
    if s[0] != 0:
      let nF = if s[s[0]] != 0: nFlips() else: 1
      maxFlips = max(maxFlips, nF)
      inc(checksum, (if ix mod 2 == 0: -1 else: +1) * nF)
  checksumRes[] = checksum
  maxFlipsRes[] = maxFlips

proc main() =
  let n = parseInt(paramStr(1))
  const nBlk = 48    #Multiple of No.CPUs; 48=LCM(4,6,8,12,16) (n<5 => fail)
  let blkLen = fac(n) div nBlk # could use factorial[], but eh.
  var maxFlipsT, checksumT: array[nBlk, int]
  parallel:
    for b in 0 ..< nBlk:
      spawn permBlock(b, blkLen, n, addr maxFlipsT[b], addr checksumT[b])
  echo sum(checksumT)
  echo "Pfannkuchen(", n, ") = ", max(maxFlipsT)
main()
