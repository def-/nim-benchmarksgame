#!/bin/sh

NIM="nim -d:release --verbosity:0 c"

$NIM bench.nim

compile() {
  $NIM $3 --cc:$2 -o:$1_nim_$2 $1.nim
}

compile_both() {
  echo $1
  compile $1 gcc $2
  compile $1 clang $2
}

compile_both nbody
compile_both nbody_2
compile_both nbody_3

compile_both pidigits_gmp
compile_both pidigits_bigints

compile_both fastaredux

compile_both binarytrees
compile_both binarytrees_2 --threads:on
compile_both binarytrees_3 --threads:on
compile_both binarytrees_op

compile_both fannkuch --threads:on
compile_both fannkuch0
compile_both fannkuch1
compile_both fannkuch2
compile_both fannkuch3
compile_both fannkuch4
compile_both fannkuch5
compile_both fannkuchST

compile_both knucleotide --threads:on
compile_both knucleotide2pass --threads:on
compile_both knucleotideST

compile_both mandelbrot --threads:on
compile_both mandelbrot8 --threads:on

#compile_both perms

compile_both regex

compile_both revcomp

compile_both spectralnorm --threads:on

gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -mfpmath=sse -msse3 -lm -o nbody_c nbody.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -lgmp -o pidigits_c pidigits.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 -mfpmath=sse -msse3 -o fastaredux_c fastaredux.c
#gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -D_FILE_OFFSET_BITS=64 -I/usr/include/apr-1.0 -o binarytrees_c binarytrees.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -lpcre -o regex_c regex.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -funroll-loops -fopenmp -o revcomp_c revcomp.c
#gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -std=c99 -IInclude -o knucleotide_c knucleotide.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -std=c99 -fopenmp -o fannkuch_c fannkuch.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -mno-fma -fno-finite-math-only -mfpmath=sse -msse2 -fopenmp -o mandelbrot_c mandelbrot.c
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -mfpmath=sse -msse2 -lm -o spectralnorm_c spectralnorm.c
