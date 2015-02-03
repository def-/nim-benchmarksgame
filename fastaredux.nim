# From https://gist.github.com/idlewan/ab53b761ab1522251682
import os, strutils

const
    IM = 139968
    IA = 3877
    IC = 29573

const
    LINE_LEN = 60
    LOOKUP_SIZE = 4096
    LOOKUP_SCALE = (LOOKUP_SIZE - 1).float

proc fwrite_unlocked(buf: pointer, size, n: int, stream: File): int
    {.cdecl, importc: "fwrite_unlocked", header: "<stdio.h>".}
proc fputc_unlocked(c: int, stream: File): int
    {.cdecl, importc: "fputc_unlocked", header: "<stdio.h>".}


proc repeat(alu: var array[0..286, char], title: string, nb: int) =
    var buf: array[0 .. alu.len + LINE_LEN, char]
    var pos = 0

    copyMem(addr buf, addr alu, alu.len)
    copyMem(cast[pointer](cast[int](addr buf) + alu.len),
            addr alu, LINE_LEN)

    discard fwrite_unlocked(cast[pointer](title.cstring),
                            title.len, 1, stdout)
    var n = nb
    while n > 0:
        let bytes = if n > LINE_LEN: LINE_LEN else: n

        discard fwrite_unlocked(cast[pointer]( cast[int](buf.addr) + pos),
                                bytes, 1, stdout)
        pos += bytes
        if pos > alu.len:
            pos -= alu.len
        discard fputc_unlocked('\L'.int, stdout)
        n -= bytes

type
    AminoAcid = tuple[
        sym: char,
        prob, cprob_lookup: float
    ]
    LUT = array[0.. LOOKUP_SIZE - 1, ptr AminoAcid]

proc random_next_lookup(random: ptr int): float
    {.noSideEffect, inline.} =
    random[] = (random[] * IA + IC) mod IM
    return random[].float * LOOKUP_SCALE / IM

proc fill_lookup(lookup: var LUT, amino_acid: var openarray[AminoAcid]) =
    var p: float
    for i in 0 .. <amino_acid.len:
        p += amino_acid[i].prob
        amino_acid[i].cprob_lookup = p*LOOKUP_SCALE

        # prevent rounding error
        amino_acid[amino_acid.len - 1].cprob_lookup = LOOKUP_SIZE - 1

        for i in 0 .. <LOOKUP_SIZE:
            var j = 0
            while amino_acid[j].cprob_lookup < i.float:
                j += 1
            lookup[i] = addr amino_acid[j]

proc randomize(amino_acid: var openarray[AminoAcid], title: string,
               n: int, rand: ptr int) =
    var lookup: LUT
    var line_buffer: array[0..LINE_LEN, char]

    line_buffer[LINE_LEN] = '\L'

    fill_lookup(lookup, amino_acid)

    discard fwrite_unlocked(cast[pointer](title.cstring),
                            title.len, 1, stdout)

    var j = 0
    for i in 0 .. <n:
        if j == LINE_LEN:
            discard fwrite_unlocked(line_buffer[0].addr,
                                    line_buffer.len, 1, stdout)
            j = 0

        let r = random_next_lookup(rand)
        var u = lookup[r.int16]
        while u.cprob_lookup < r:
            u = cast[ptr AminoAcid](cast[int](u) + sizeof(AminoAcid))
        line_buffer[j] = u.sym
        j += 1

    line_buffer[j] = '\L'
    discard fwrite_unlocked(line_buffer[0].addr, j + 1, 1, stdout)



const alu: cstring = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG" &
   "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA" &
   "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA" &
   "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT" &
   "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC" &
   "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG" &
   "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

var iub: array[0..14, AminoAcid] = [
   ('a', 0.27, 0.0),
   ('c', 0.12, 0.0),
   ('g', 0.12, 0.0),
   ('t', 0.27, 0.0),

   ('B', 0.02, 0.0),
   ('D', 0.02, 0.0),
   ('H', 0.02, 0.0),
   ('K', 0.02, 0.0),
   ('M', 0.02, 0.0),
   ('N', 0.02, 0.0),
   ('R', 0.02, 0.0),
   ('S', 0.02, 0.0),
   ('V', 0.02, 0.0),
   ('W', 0.02, 0.0),
   ('Y', 0.02, 0.0),
]

var homo_sapiens: array[0..3, AminoAcid] = [
   ('a', 0.3029549426680, 0.0),
   ('c', 0.1979883004921, 0.0),
   ('g', 0.1975473066391, 0.0),
   ('t', 0.3015094502008, 0.0),
]


var n = 512
if paramCount() > 0:
    n = paramStr(1).parseInt

repeat(cast[var array[0..286, char]](alu),
       ">ONE Homo sapiens alu\n", n*2)

var random = 42
randomize(iub, ">TWO IUB ambiguity codes\L",
          n*3, addr random)
randomize(homo_sapiens, ">THREE Homo sapiens frequency\L",
          n*5, addr random)
