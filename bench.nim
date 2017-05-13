import times, strutils, os, osproc, posix, streams

type Rusage {.importc: "struct rusage", header: "<sys/resource.h>",
              final, pure.} = object
  ru_utime, ru_stime: Timeval
  ru_maxrss, ru_ixrss, ru_idrss, ru_isrss, ru_minflt, ru_majflt, ru_nswap,
    ru_inblock, ru_oublock, ru_msgsnd, ru_msgrcv, ru_nsignals, ru_nvcsw,
    ru_nivcsw: clong

proc wait4(pid: Pid, status: ptr cint, options: cint, rusage: ptr Rusage): Pid
  {.importc, header: "<sys/wait.h>", discardable.}

const
  maxlen = 30
  buflen = 8192
let
  name = paramStr(1)
  params = commandLineParams()
  t0 = epochTime()
var
  rusage: Rusage
  buffer: array[buflen, char]
  p = startProcess("./" & name, args = params[1 .. ^1])
  outp = p.outputStream

while outp.readData(addr buffer[0], buflen) > 0: discard

wait4(Pid(p.processID), nil, 0, addr rusage)

let t1 = epochTime()

echo "| ", name, spaces(maxlen - name.len), " | ",
  formatFloat(t1-t0, ffDecimal, 2).align(8), " | ",
  align($rusage.ru_maxrss, 11), " |"
