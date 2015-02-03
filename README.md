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
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| nbody_nim_gcc                  |    12.28 |        1796 |
| nbody_nim_clang                |    15.78 |        1720 |
| nbody_2_nim_gcc                |    10.66 |        1808 |
| nbody_2_nim_clang              |    15.38 |        1764 |
| nbody_c                        |    10.25 |        1508 |

## pidigits
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| pidigits_gmp_nim_gcc           |     1.67 |        2812 |
| pidigits_gmp_nim_clang         |     1.66 |        2604 |
| pidigits_bigints_nim_gcc       |    27.70 |        7976 |
| pidigits_bigints_nim_clang     |    26.84 |        8992 |
| pidigits_c                     |     1.69 |        2308 |

## fastaredux
| Implementation                 | Time [s] | Memory [KB] |
| ------------------------------ | --------:| -----------:|
| fastaredux_nim_gcc             |     7.10 |        1388 |
| fastaredux_nim_clang           |     6.90 |        1284 |
| fastaredux_c                   |     7.13 |        1380 |

## Related work
There are some other nice benchmarks online comparing Nim to other languages:

- https://togototo.wordpress.com/2013/08/23/benchmarks-round-two-parallel-go-rust-d-scala-and-nimrod/
- https://github.com/logicchains/LPATHBench/blob/master/writeup.md
- https://github.com/andreaferretti/kmeans
- https://github.com/kostya/benchmarks
- https://github.com/nsf/pnoise
