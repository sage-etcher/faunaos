#!/usr/bin/env sh
dd if=/dev/zero of=$1 bs=512 ibs=512 obs=512 count=4
dd if=$2 of=$1 bs=512 ibs=512 obs=512 count=4 seek=4
dd if=/dev/zero of=$1 bs=512 ibs=512 obs=512 count=692 seek=8
