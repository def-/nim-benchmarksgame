import os, strutils

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
  var c = s
  zeroMem(addr c[0], N * sizeof(c[0]))  # Tompkin-Paige permutation generation
  var i = 0
  while i < N:
    let tmp = s[0] # rotate s[]
    moveMem(addr s[0], addr s[1], i * sizeof(s[0]))
    s[i] = tmp
    if c[i] >= i: # skip this one
      c[i] = 0
      inc(i)
      continue
    inc(c[i])
    i = 1
    # Operate on permutation in-line
    sign = -sign # loop struct skips ident perm, but that also has s[0] == 0
    if s[0] != 0:
      let nF = if s[s[0]] != 0: nFlips() else: 1
      maxflips = max(maxflips, nF)
      inc(checksum, sign * nF)
  echo checksum
  echo "Pfannkuchen(", N, ") = ", maxflips
main()
