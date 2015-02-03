# Nim implementations for The Computer Language Benchmarks Game

Compared to C implementations from http://benchmarksgame.alioth.debian.org/ .
These are among the fastest. All benchmarks run on my Intel Core2Quad Q9300,
x86_64, single core.

See each file for information about where it's from. Contributions are welcome.

To run the benchmarks on your machine:
```
./compile.sh
./run.sh
```

## nbody
| Implementation                 | Time [s] |
| ------------------------------ | --------:|
| nbody_nim_gcc                  |    12.19 |
| nbody_nim_clang                |    15.72 |
| nbody_2_nim_gcc                |    10.63 |
| nbody_2_nim_clang              |    15.34 |
| nbody_c                        |    10.18 |

## pidigits
| Implementation                 | Time [s] |
| ------------------------------ | --------:|
| pidigits_gmp_nim_gcc           |     1.66 |
| pidigits_gmp_nim_clang         |     1.66 |
| pidigits_bigints_nim_gcc       |    27.54 |
| pidigits_bigints_nim_clang     |    26.86 |
| pidigits_c                     |     1.66 |

## fastaredux
| Implementation                 | Time [s] |
| ------------------------------ | --------:|
| fastaredux_nim_gcc             |     7.93 |
| fastaredux_nim_clang           |     7.63 |
| fastaredux_c                   |     8.09 |

## Related work
There are some other nice benchmarks online comparing Nim to other languages:

- https://togototo.wordpress.com/2013/08/23/benchmarks-round-two-parallel-go-rust-d-scala-and-nimrod/
- https://github.com/logicchains/LPATHBench/blob/master/writeup.md
- https://github.com/andreaferretti/kmeans
- https://github.com/kostya/benchmarks
- https://github.com/nsf/pnoise
