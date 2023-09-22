#!/bin/sh

inputFile = $1

aarch64-linux-gnu-as $1 -o a.o
aarch64-linux-gnu-ld a.o
qemu-aarch64 a.out