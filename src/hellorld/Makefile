
.SUFFIXES: .asm .c .rel

EXTERNAL = ../external

PORT_FLAGS = --std-sdcc99 -mz80 -pz80 --portmode=z80 --sdcccall 1 \
             --nostdinc --nostdlib --no-std-crt0

EXTRA_CFLAGS  := $(PORT_FLAGS) -I. -I$(EXTERNAL) \
                 --callee-saves --fomit-frame-pointer

EXTRA_LDFLAGS := $(PORT_FLAGS) --out-fmt-ihx \
                 --xram-loc 0xc000 --xram-size 0x0800 \
                 --code-loc 0xc00a

build: hellorld.bin

clean:
	rm -f *.lst *.rel *.sym         # build artifacts
	rm -f *.ihx *.lk *.map *.noi    # link artifacts 
	rm -f .tmp.*                    # temporary build files
	rm -f hellorld.asm hellorld.bin

# hellorld
.asm.rel:
	sdasz80 -glos $@ $<

.c.asm:
	sdcc -E $< $(EXTRA_CFLAGS) $(CFLAGS) |\
		sdcc --c1mode -o $@ $(EXTRA_CFLAGS) $(CFLAGS)

hellorld.ihx: crt0.rel hellorld.rel $(EXTERNAL)/z80std.rel $(EXTERNAL)/advantage_prom.rel
	sdcc -o $@ $^ $(EXTRA_LDFLAGS) $(LDFLAGS)

hellorld.bin: hellorld.ihx
	cp $< .tmp.$<
	hex2bin -e bin -m 0x0800 -l 0x0800 -s 0xc000 .tmp.$< >/dev/null
	printf '\xc0'         |dd of=.tmp.$@ bs=1 seek=0  count=1 conv=notrunc status=none
	printf '\xc3\x10\xc0' |dd of=.tmp.$@ bs=1 seek=10 count=3 conv=notrunc status=none
	mv .tmp.$@ $@
	rm -f .tmp.$<

PHONY: build clean
# end of file
