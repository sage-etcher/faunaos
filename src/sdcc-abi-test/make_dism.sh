#!/usr/bin/env sh

org=0100
binfile=$1
mapfile=$2
basename=$3

tmp_a=".tmp.$basename.a"
tmp_b_sh=".tmp.$basename.b.sh"
tmp_b=".tmp.$basename.b"
tmp_c_sh=".tmp.$basename.c.sh"
tmp_c=".tmp.$basename.c"
tmp_d=".tmp.$basename.d"
output="${basename}_dis.asm"

rm -f $tmp_a $tmp_b_sh $tmp_b $tmp_c_sh $tmp_c $tmp_d $output

~/local/disi80/dismz80intel $org $binfile >$tmp_a

~/local/disi80/scripts/sdccmap_to_sedfile i8080 $mapfile $tmp_b_sh
chmod +x $tmp_b_sh
./$tmp_b_sh $tmp_a >$tmp_b

~/local/disi80/scripts/dism_add_negative $tmp_b >$tmp_c_sh
chmod +x $tmp_c_sh
./$tmp_c_sh $tmp_b >$tmp_c

~/local/disi80/scripts/dism_realign $tmp_c >$tmp_d

cp -f $tmp_d $output
