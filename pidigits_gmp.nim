## From https://github.com/cowboy-coders/nim-gmp
## pidigits from computer language benchmark game
## ported from original c version by Mr Ledrug, see:
## http://benchmarksgame.alioth.debian.org/u64q/program.php?test=pidigits&lang=gcc&id=1

import gmp
import gmp/utils
import strutils
import os

var tmp1, tmp2, acc, den, num: mpz_t

proc extract_digit(nth: culong): culong =
  # joggling between tmp1 and tmp2, so GMP won't have to use temp buffers
  mpz_mul_ui(tmp1, num, nth)
  mpz_add(tmp2, tmp1, acc)
  mpz_tdiv_q(tmp1, tmp2, den)
  result = mpz_get_ui(tmp1)

proc eliminate_digit(d: culong) =
   mpz_submul_ui(acc, den, d)
   mpz_mul_ui(acc, acc, 10)
   mpz_mul_ui(num, num, 10)

proc next_term(k: culong) =
   var k2: culong = k * 2 + 1
   mpz_addmul_ui(acc, num, 2)
   mpz_mul_ui(acc, acc, k2)
   mpz_mul_ui(den, den, k2)
   mpz_mul_ui(num, num, k)

var d, k: culong
var i: uint64
var n: int = parseInt paramStr(1)

mpz_init(tmp1)
mpz_init(tmp2)

mpz_init_set_ui(acc, 0)
mpz_init_set_ui(den, 1)
mpz_init_set_ui(num, 1)

while(i < n.uint64):
  inc k
  next_term(k)
  if mpz_cmp(num, acc) > 0:
    continue

  d = extract_digit(3)
  if d != extract_digit(4):
    continue
  stdout.write(chr(ord('0').uint64 + d))
  inc i
  if (i mod 10'u64).uint64 == 0'u64:  echo "\t:" & $i
  eliminate_digit(d)
