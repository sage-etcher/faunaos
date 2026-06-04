#!/usr/bin/env bash
boot_blks=${3:-4}
suffix_blks=$((696-$boot_blks))

dd if=/dev/zero of=$1 bs=512 ibs=512 obs=512 count=4 status=none
dd if=$2 of=$1 bs=512 ibs=512 obs=512 count=$boot_blks seek=4 status=none
dd if=/dev/zero of=$1 bs=512 ibs=512 obs=512 count=$suffix_blks seek=$(($boot_blks+4)) status=none
