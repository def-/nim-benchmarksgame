# by john_smith

import os, strutils

type
  TreeNode[T] = ref object {.acyclic.}
    item: T
    left, right: TreeNode[T]

proc bottomUpTree(item, depth: int32): TreeNode[int32] =
  new result
  result.item = item
  if depth > 0:
    result.left = bottomUpTree(2*item-1, depth-1)
    result.right = bottomUpTree(2*item, depth-1)

proc itemCheck(noderef: TreeNode[int32]): int32 =
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

var check = bottomUpTree(0, stretchDepth).itemCheck
echo "stretch tree of depth ", stretchDepth, "\t check: ", check

let longLivedTree = bottomUpTree(0, maxDepth)

for depth in countup(minDepth, maxDepth, 2):
  let iterations = 1 shl (maxDepth - depth + minDepth)
  check = 0

  for i in 1 .. iterations:
    check += bottomUpTree(i, depth).itemCheck +
             bottomUpTree(-i, depth).itemCheck

  echo((iterations*2), "\t trees of depth ", depth, "\t check: ", check)

echo "long lived tree of depth ", maxDepth, "\t check: ", longLivedTree.itemCheck
