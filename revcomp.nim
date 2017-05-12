import algorithm

proc revWr(sq: var string) {.inline.} =
  sq.reverse()
  var start = 0
  while start < sq.len:
    stdout.write sq[start .. start + 59]
    stdout.write "\n"
    start += 60

proc main() =
  let src = "ACBDGHKMNSRUTWVYacbdghkmnsrutwvy"
  let dst = "TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR"
  var complement: array[256, char]
  for i, c in src:
    complement[ord(c)] = dst[i]
  var sq = ""
  for line in lines(stdin):
    if line[0] == '>':
      if sq.len > 0:
        revWr(sq)
      sq.setLen(0)
      echo line
    else:
      for c in line:
        sq.add complement[ord(c)]
  if sq.len > 0: revWr(sq)

main()
