#!/bin/sh

echo "## nbody"
echo "| Implementation                 | Time [s] |"
echo "| ------------------------------ | --------:|"
./bench nbody_nim_gcc 50000000
./bench nbody_nim_clang 50000000
./bench nbody_2_nim_gcc 50000000
./bench nbody_2_nim_clang 50000000
./bench nbody_c 50000000

echo -e "\n## pidigits"
echo "| Implementation                 | Time [s] |"
echo "| ------------------------------ | --------:|"
./bench pidigits_gmp_nim_gcc 10000
./bench pidigits_gmp_nim_clang 10000
./bench pidigits_bigints_nim_gcc 10000
./bench pidigits_bigints_nim_clang 10000
./bench pidigits_c 10000

echo -e "\n## fastaredux"
echo "| Implementation                 | Time [s] |"
echo "| ------------------------------ | --------:|"
./bench fastaredux_nim_gcc 25000000
./bench fastaredux_nim_clang 25000000
./bench fastaredux_c 25000000
