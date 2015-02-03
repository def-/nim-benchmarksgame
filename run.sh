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
