#!/usr/bin/env bash
#
function offset { # uint32_t offset(side, track, sector)
    local side=$1
    local track=$2
    local sector=$3

    local abs_track=0
    if [ "x$side" == 'x1' ]; then
        abs_track=$(( 69 - $track ))
    else
        abs_track=$track
    fi

    echo $(( $abs_track * 10 + $sector ))
}

bin=bootloader_boot.bin
nsi=faunboot.nsi
embed=embed.bin
embed_h=embed.h

dd if=/dev/random of=$embed bs=512 skip=0   seek=0                count=16  status=none conv=notrunc
xxd -i -C $embed $embed_h

dd if=/dev/zero   of=$nsi   bs=512 skip=0   seek=$(offset 0  0 0) count=700 status=none conv=notrunc
dd if=$bin        of=$nsi   bs=512 skip=0   seek=$(offset 0  0 4)           status=none conv=notrunc
dd if=$embed      of=$nsi   bs=512 skip=0   seek=$(offset 0 33 8) count=12  status=none conv=notrunc
dd if=$embed      of=$nsi   bs=512 skip=12  seek=$(offset 1  0 0) count=4   status=none conv=notrunc
dd if=$embed      of=$nsi   bs=512 skip=0   seek=$(offset 1 33 8) count=12  status=none conv=notrunc
dd if=$embed      of=$nsi   bs=512 skip=12  seek=$(offset 0  0 0) count=4   status=none conv=notrunc

# end of file
