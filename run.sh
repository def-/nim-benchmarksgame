#!/bin/sh

function header()
{
echo "## $1"
echo "| Implementation                 | Time [s] | Memory [KB] |"
echo "| ------------------------------ | --------:| -----------:|"
}

header nbody
./bench nbody_nim_gcc 50000000
./bench nbody_nim_clang 50000000
./bench nbody_2_nim_gcc 50000000
./bench nbody_2_nim_clang 50000000
./bench nbody_3_nim_gcc 50000000
./bench nbody_3_nim_clang 50000000
./bench nbody_c 50000000

header pidigits
./bench pidigits_gmp_nim_gcc 10000
./bench pidigits_gmp_nim_clang 10000
./bench pidigits_bigints_nim_gcc 10000
./bench pidigits_bigints_nim_clang 10000
./bench pidigits_c 10000

header fastaredux
./bench fastaredux_nim_gcc 25000000
./bench fastaredux_nim_clang 25000000
./bench fastaredux_c 25000000

header binarytrees
./bench binarytrees_nim_gcc 21
./bench binarytrees_nim_clang 21
./bench binarytrees_2_nim_gcc 21
./bench binarytrees_2_nim_clang 21
./bench binarytrees_3_nim_gcc 21
./bench binarytrees_3_nim_clang 21
./bench binarytrees_op_nim_gcc 21
./bench binarytrees_op_nim_clang 21
#./bench binarytrees_c 21

header fannkuch
./bench fannkuch_nim_gcc 12
./bench fannkuch_nim_clang 12
./bench fannkuch2_nim_gcc 12
./bench fannkuch2_nim_clang 12
./bench fannkuch3_nim_gcc 12
./bench fannkuch3_nim_clang 12
./bench fannkuch4_nim_gcc 12
./bench fannkuch4_nim_clang 12
./bench fannkuch5_nim_gcc 12
./bench fannkuch5_nim_clang 12
./bench fannkuchST_nim_gcc 12
./bench fannkuchST_nim_clang 12
./bench fannkuch_c 12

#header knucleotide
#./bench knucleotide_nim_gcc 0 < knucleotide-input0.txt
#./bench knucleotide_nim_clang 0 < knucleotide-input0.txt
#./bench knucleotide2pass_nim_gcc 0 < knucleotide-input0.txt
#./bench knucleotide2pass_nim_clang 0 < knucleotide-input0.txt
#./bench knucleotideST_nim_gcc 0 < knucleotide-input0.txt
#./bench knucleotideST_nim_clang 0 < knucleotide-input0.txt
#./bench knucleotide_c 0 < knucleotide-input0.txt

header mandelbrot
./bench mandelbrot_nim_gcc 16000
./bench mandelbrot_nim_clang 16000
./bench mandelbrot8_nim_gcc 16000
./bench mandelbrot8_nim_clang 16000
./bench mandelbrot_c 16000

#header regex
#./bench regex_nim_gcc 0 < regexdna-input0.txt
#./bench regex_nim_clang 0 < regexdna-input0.txt
#./bench regex_c 0 < regexdna-input0.txt

#header revcomp
#./bench revcomp_nim_gcc 0 < revcomp-input0.txt
#./bench revcomp_nim_clang 0 < revcomp-input0.txt
#./bench revcomp_c 0 < revcomp-input0.txt

header spectralnorm
./bench spectralnorm_nim_gcc 5500
./bench spectralnorm_nim_clang 5500
./bench spectralnorm_c 5500
