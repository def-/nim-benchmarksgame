proc permutationParity*[SomeInt](p: openArray[SomeInt]): int =
  ## This computes the parity of a permutation
  let n = len(p)
  var visited = newSeq[bool](n)   # Logical vector which marks all p(k)
  result = 1 
  for k in 0 ..< n:
    if not visited[k]:            # k not visited, start of new cycle
      var next = k
      var L = 0 
      while not visited[next]:    # Traverse the current cycle k
        L = L + 1                 # and find its length L
        visited[next] =  true
        next = p[next]
      if (L and 1) == 0:          # If L is even, change sign.
        result = -result

iterator permutations*[T](s: var openArray[T], n: int): bool {.inline.} =
  ## Replaces `s` with each permutation of itself.  The variable parameter `s`
  ## is updated as the iterator proceeds.  So, just use `s`.
  yield true
# let n = len(s)                #B.Heap's algo for perm generation
  var c = newSeq[int](n)
  var i = 0
  while i < n:
    if c[i] < i:
      let toSwap = (i and 1) * c[i]
      swap(s[toSwap], s[i])
      yield true
      inc(c[i])
      i = 0
    else:
      c[i] = 0
      inc(i)
iterator permutations*[T](s: var openArray[T]): bool {.inline.} =
  ## `permutations` wrapper with no length argument uses len of openArray
  for x in permutations(s, len(s)): yield x

iterator permutationsTK*[T](s: var openArray[T], n: int): bool {.inline.} =
  ## Tompkin-Paige iteration over perms of a seq
  var c = newSeq[int](n)
  var i = 0
  yield true # identity perm
  while i < n:
    let tmp = s[0] # rotate s[]
    moveMem(addr s[0], addr s[1], i * sizeof(s[0]))
    s[i] = tmp
    if c[i] >= i: # skip this one
      c[i] = 0
      inc(i)
      continue
    yield true
    inc(c[i])
    i = 1
iterator permutationsTK*[T](s: var openArray[T]): bool {.inline.} =
  ## `permutationsTK` wrapper with no length argument uses len of openArray
  for x in permutations(s, len(s)): yield x

proc nextPermTK*[T](s,c: var openArray[T], n: int, i: var int): bool {.inline.}=
  ## Caller must start c[] with all zeros and i = 0
  while i < n:
    let tmp = s[0] # rotate s[]
    moveMem(addr s[0], addr s[1], i * sizeof(s[0]))
    s[i] = tmp
    if c[i] >= i: # skip this one
      c[i] = 0
      inc(i)
      continue
    inc(c[i])
    i = 1
    return true
  return false

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

iterator parPerms*[T](s: var openArray[T]; b, blkLen: int): bool =
  ## `parPerms` wrapper with no length argument uses len of openArray
  for x in parPerms(s, b, blkLen, len(s)): yield x
