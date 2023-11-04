#!/bin/sh

aarch64-linux-gnu-gcc indietest.c itoascii.s concat_array.s count_specs.s pringle.s -g 
qemu-aarch64 -L /usr/aarch64-linux-gnu/ -g 1235 a.out 