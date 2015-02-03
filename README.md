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
| nbody_nim_gcc                  |    12.19 |        1872 |
| nbody_nim_clang                |    15.74 |        1780 |
| nbody_2_nim_gcc                |    10.64 |        1776 |
| nbody_2_nim_clang              |    15.36 |        1728 |
| nbody_c                        |    10.18 |        1716 |

## pidigits
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| pidigits_gmp_nim_gcc           |     1.67 |        2740 |
| pidigits_gmp_nim_clang         |     1.67 |        2748 |
| pidigits_bigints_nim_gcc       |    31.82 |        8020 |
| pidigits_bigints_nim_clang     |    26.65 |        8984 |
| pidigits_c                     |     1.66 |        2292 |

## fastaredux
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| fastaredux_nim_gcc             |     2.73 |        1384 |
| fastaredux_nim_clang           |     3.15 |        1348 |
| fastaredux_c                   |     1.87 |        1352 |

## Related work
There are some other nice benchmarks online comparing Nim to other languages:

- https://togototo.wordpress.com/2013/08/23/benchmarks-round-two-parallel-go-rust-d-scala-and-nimrod/
- https://github.com/logicchains/LPATHBench/blob/master/writeup.md
- https://github.com/andreaferretti/kmeans
- https://github.com/kostya/benchmarks
- https://github.com/nsf/pnoise
