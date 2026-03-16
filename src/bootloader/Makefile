
.SUFFIXES: .c .rel

EXTERNAL = ../external

PORT_FLAGS = --std-sdcc99 -mz80 -pz80 --sdcccall 1
EXTRA_CFLAGS  := $(PORT_FLAGS) --nostdinc -I. -I$(EXTERNAL)
EXTRA_LDFLAGS := $(PORT_FLAGS) --nostdlib --no-std-crt0

build: cpmload.com bootloader.bin

clean:
	rm -f *.asm *.lst *.rel *.sym   # build artifacts
	rm -f *.ihx *.lk *.map *.noi    # link artifacts 
	rm -f .tmp.*                    # temporary build files
	rm -f cpmload.com
	rm -f bootloader.bin

cleaner: clean
	rm -f compile_commands.json

# cpmload
cpmload.ihx: cpmload.rel $(EXTERNAL)/z80std.rel $(EXTERNAL)/cpmstd.rel
	sdcc $^ $(EXTRA_LDFLAGS) $(LDFLAGS) \
		--code-loc 0x0100 --code-size 0x0e00 \
		--data-loc 0x1000 --stack-loc 0x1000

cpmload.com: cpmload.ihx
	hex2bin -e com -m 0x080 -s 0x0100 $< >/dev/null

# bootloader
bootloader.ihx: bootloader.rel $(EXTERNAL)/z80std.rel
	sdcc $^ $(EXTRA_LDFLAGS) $(LDFLAGS) \
		--code-loc 0xc010 --code-size 0x05f0 \
		--data-loc 0xc600 --stack-loc 0xc000

bootloader.bin: bootloader.ihx
	cp $< .tmp.$<
	hex2bin -e bin -m 0x0800 -l 0x0800 -s 0xc000 .tmp.$< >/dev/null
	printf '\xc0'         |dd of=.tmp.$@ bs=1 seek=0  count=1 conv=notrunc status=none
	printf '\xc3\x10\xc0' |dd of=.tmp.$@ bs=1 seek=10 count=3 conv=notrunc status=none
	mv .tmp.$@ $@
	rm -f .tmp.$<

# general
.c.rel:
	sdcc -c $< $(EXTRA_CFLAGS) $(CFLAGS)

PHONY: build clean
# end of file
