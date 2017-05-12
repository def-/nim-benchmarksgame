import os, strutils, perms

proc main() =
  let N = parseInt(paramStr(1))
  var s, P: array[16, int]    # P: Re-used mutable permutation
  for i in 0 ..< N: s[i] = i

  proc nFlips(): int {.inline.} =
    copyMem(addr P[0], addr s[0], N * sizeof(s[0])) # set P[] to current perm
    var i = 1
    while true:
      var x = 0 # reverse(P, 0, P[0]) is ~6% slower (not-inline & arg copy)
      var y = P[0]
      while x < y:
        swap(P[x], P[y])
        inc(x); dec(y)
      inc(i)
      if P[P[0]] == 0:
        break
    return i

  var maxflips = 0
  var checksum = 0
  var sign = +1
  for x in permutations(s, N):
    if s[0] != 0:
      let nF = if s[s[0]] != 0: nFlips() else: 1
      maxflips = max(maxflips, nF)
      inc(checksum, sign * nF)
    sign = -sign
  echo checksum
  echo "Pfannkuchen(", N, ") = ", maxflips
main()
