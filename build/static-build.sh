#!/bin/bash

csc -I ../ -O3 -c -static -J ../advents/utils.scm -unit aoc-utils -o aoc-utils.o

for i in 1 2 3 4 5 6 7; do
    csc -I ../ -O3 -c -static -J aoc-utils.o -uses aoc-utils ../advents/2015/aoc2015day0${i}.scm -unit aoc2015day0${i} -o aoc2015day0${i}.o
done

csc -o advent2015 -static aoc2015day01.o aoc2015day02.o aoc2015day03.o aoc2015day04.o aoc2015day05.o aoc2015day06.o aoc2015day07.o aoc-utils.o -uses aoc2015day01 -uses aoc2015day02 -uses aoc2015day03 -uses aoc2015day04 -uses aoc2015day05 -uses aoc2015day06 -uses aoc2015day07 -uses aoc-utils ../advents/2015/advent2015.scm
