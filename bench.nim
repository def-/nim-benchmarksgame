import times, osproc, os, strutils

const maxlen = 30
let name = paramStr(1)
let params = commandLineParams()[1 .. -1]
let t0 = epochTime()
discard execProcess("./" & name, params, options = {poStdErrToStdOut})
let t1 = epochTime()
echo "| ", name, repeatChar(maxlen - name.len), " | " , formatFloat(t1-t0, ffDecimal, 2).align(8), " |"
