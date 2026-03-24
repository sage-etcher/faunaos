
.SUFFIXES: .c .rel

EXTERNAL = ../external

PORT_FLAGS = --std-sdcc99 -mz80 -pz80 --sdcccall 1
EXTRA_CFLAGS  := $(PORT_FLAGS) --nostdinc -I. -I$(EXTERNAL)
EXTRA_LDFLAGS := $(PORT_FLAGS) --nostdlib --no-std-crt0

build: hellorld.bin

clean:
	rm -f *.asm *.lst *.rel *.sym   # build artifacts
	rm -f *.ihx *.lk *.map *.noi    # link artifacts 
	rm -f .tmp.*                    # temporary build files
	rm -f hellorld.bin

# hellorld
.c.rel:
	sdcc -c $< $(EXTRA_CFLAGS) $(CFLAGS)

hellorld.ihx: hellorld.rel $(EXTERNAL)/z80std.rel
	sdcc $^ $(EXTRA_LDFLAGS) $(LDFLAGS) \
		--code-loc 0xc010 --code-size 0x05f0 \
		--data-loc 0xc600 --stack-loc 0xc000

hellorld.bin: hellorld.ihx
	cp $< .tmp.$<
	hex2bin -e bin -m 0x0800 -l 0x0800 -s 0xc000 .tmp.$< >/dev/null
	printf '\xc0'         |dd of=.tmp.$@ bs=1 seek=0  count=1 conv=notrunc status=none
	printf '\xc3\x10\xc0' |dd of=.tmp.$@ bs=1 seek=10 count=3 conv=notrunc status=none
	mv .tmp.$@ $@
	rm -f .tmp.$<

PHONY: build clean
# end of file
