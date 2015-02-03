#!/bin/sh
NIM="nim -d:release --verbosity:0 c"

$NIM bench.nim

$NIM --cc:gcc -o:nbody_nim_gcc nbody.nim
$NIM --cc:clang -o:nbody_nim_clang nbody.nim

$NIM --cc:gcc -o:nbody_2_nim_gcc nbody_2.nim
$NIM --cc:clang -o:nbody_2_nim_clang nbody_2.nim

gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -lm -o nbody_c nbody.c

$NIM --cc:gcc -o:pidigits_gmp_nim_gcc pidigits_gmp.nim
$NIM --cc:clang -o:pidigits_gmp_nim_clang pidigits_gmp.nim

$NIM --cc:gcc -o:pidigits_bigints_nim_gcc pidigits_bigints.nim
$NIM --cc:clang -o:pidigits_bigints_nim_clang pidigits_bigints.nim

gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -lgmp -o pidigits_c pidigits.c

$NIM --cc:gcc -o:fastaredux_nim_gcc fastaredux.nim
$NIM --cc:clang -o:fastaredux_nim_clang fastaredux.nim

gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 -mfpmath=sse -msse3 -o fastaredux_c fastaredux.c
