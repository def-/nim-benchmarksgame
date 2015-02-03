import times, strutils, os, osproc, posix, streams

type Rusage {.importc: "struct rusage", header: "<sys/resource.h>",
              final, pure.} = object
  ru_utime, ru_stime: Timeval
  ru_maxrss, ru_ixrss, ru_idrss, ru_isrss, ru_minflt, ru_majflt, ru_nswap,
    ru_inblock, ru_oublock, ru_msgsnd, ru_msgrcv, ru_nsignals, ru_nvcsw,
    ru_nivcsw: clong

proc wait4(pid: TPid, status: ptr cint, options: cint, rusage: ptr Rusage): TPid
  {.importc, header: "<sys/wait.h>", discardable.}

let
  maxlen = 30
  name = paramStr(1)
  params = commandLineParams()[1 .. -1]
  t0 = epochTime()
var
  rusage: Rusage
  p = startProcess("./" & name, args = params)
  outp = p.outputStream

var line = newStringOfCap(120).TaintedString
while outp.readLine(line): discard

wait4(p.processID, nil, 0, addr rusage)

let t1 = epochTime()

echo "| ", name, repeatChar(maxlen - name.len), " | ",
  formatFloat(t1-t0, ffDecimal, 2).align(8), " | ",
  align($rusage.ru_maxrss, 11), " |"
