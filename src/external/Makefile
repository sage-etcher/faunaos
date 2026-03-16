
.SUFFIXES: .c .rel

BUILDDIR = build

PORT_FLAGS = --std-sdcc99 -mz80 -pz80 --sdcccall 1
EXTRA_CFLAGS  := $(PORT_FLAGS) --nostdinc -I.
EXTRA_LDFLAGS := $(PORT_FLAGS) --nostdlib --no-std-crt0

build: cpmstd.rel z80std.rel

clean:
	rm -f *.asm *.lst *.rel *.sym

# general
.c.rel:
	sdcc -c $< $(EXTRA_CFLAGS) $(CFLAGS)

PHONY: build clean
# end of file
