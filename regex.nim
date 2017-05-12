import re

proc main()=
  var sq = string(readAll(stdin))
  let ilen = len(sq)

  sq = replace(sq, re">.*\n|\n", "")
  let clen = len(sq)

  let variants = [ "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct" ]
  for f in variants:
    echo f, " ", len(findAll(sq, re(f)))

  let subs = { "tHa[Nt]" : "<4>",
               "aND|caN|Ha[DS]|WaS" : "<3>",
               "a[NSt]|BY" : "<2>",
               "<[^>]*>" : "|",
               "\\|[^|][^|]*\\|" : "-" }
  for r, f in subs.items():
    sq = replace(sq, re(r), f)

  echo ""
  echo ilen
  echo clen
  echo len(sq)

main()
