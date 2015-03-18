# Nim implementations for The Computer Language Benchmarks Game

Compared to C implementations from http://benchmarksgame.alioth.debian.org/ .
These are among the fastest. All benchmarks run on my Intel Core2Quad Q9300,
x86_64, single core. I'm running Linux with gcc 4.9.2, clang 3.5.1 and nim from
devel branch.

See each file for information about where it's from. Contributions are welcome.

To run the benchmarks on your machine:
```
./compile.sh
./run.sh
```

## nbody
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| nbody_nim_gcc                  |    12.25 |        1708 |
| nbody_nim_clang                |    16.90 |        1768 |
| nbody_2_nim_gcc                |    10.64 |        1932 |
| nbody_2_nim_clang              |    14.66 |        1836 |
| nbody_3_nim_gcc                |    11.17 |        1824 |
| nbody_3_nim_clang              |    14.74 |        1756 |
| nbody_c                        |    10.17 |        1596 |
## pidigits
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| pidigits_gmp_nim_gcc           |     1.70 |        2760 |
| pidigits_gmp_nim_clang         |     1.66 |        2736 |
| pidigits_bigints_nim_gcc       |    27.66 |        7968 |
| pidigits_bigints_nim_clang     |    27.28 |        8500 |
| pidigits_c                     |     1.66 |        2400 |
## fastaredux
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| fastaredux_nim_gcc             |     2.76 |        1440 |
| fastaredux_nim_clang           |     3.21 |        1384 |
| fastaredux_c                   |     1.80 |        1368 |

## Related work
There are some other nice benchmarks online comparing Nim to other languages:

- https://togototo.wordpress.com/2013/08/23/benchmarks-round-two-parallel-go-rust-d-scala-and-nimrod/
- https://github.com/logicchains/LPATHBench/blob/master/writeup.md
- https://github.com/andreaferretti/kmeans
- https://github.com/kostya/benchmarks
- https://github.com/nsf/pnoise
