import os, strutils, math

type
  TreeNode[T] = object {.acyclic.}
    item: T
    left, right: ptr TreeNode[T]

  ObjectPool = object
    objs*: seq[TreeNode[int32]]
    size*: int

proc initObjectPool(depth: int): ObjectPool =
  result.objs = newSeq[TreeNode[int32]](2 ^ (depth*4))

proc bottomUpTree(item, depth: int32, pool: var ObjectPool): ptr TreeNode[int32] =
  result = addr pool.objs[pool.size]
  inc pool.size
  result.item = item
  if depth > 0:
    result.left = bottomUpTree(2*item-1, depth-1, pool)
    result.right = bottomUpTree(2*item, depth-1, pool)

proc itemCheck(noderef: ptr TreeNode[int32]): int32 =
  if noderef.left == nil:
    result = noderef.item
  else:
    result = noderef.item + noderef.left.itemCheck - noderef.right.itemCheck

const minDepth = 4

var n: int32 = 0
if paramCount() > 0:
  n = paramStr(1).parseInt.int32

let maxDepth: int32 = if minDepth + 2 > n: minDepth + 2
                                     else: n
let stretchDepth: int32 = maxDepth + 1

var pool = initObjectPool(stretchDepth)
var check = bottomUpTree(0, stretchDepth, pool).itemCheck
echo "stretch tree of depth ", stretchDepth, "\t check: ", check

let longLivedTree = bottomUpTree(0, maxDepth, pool)

for depth in countup(minDepth, maxDepth, 2):
  let iterations = 1'i32 shl (maxDepth - depth + minDepth)
  check = 0

  var pool = initObjectPool(depth)

  for i in 1 .. iterations:
    check += bottomUpTree(i, depth, pool).itemCheck
    check += bottomUpTree(-i, depth, pool).itemCheck

  echo((iterations*2), "\t trees of depth ", depth, "\t check: ", check)

echo "long lived tree of depth ", maxDepth, "\t check: ", longLivedTree.itemCheck
