
.SUFFIXES: .asm .c .rel

#DEBUG_FLAGS = --nooverlay --nogcse --nolabelopt --noinvariant --noinduction \
#			  --noloopreverse --no-peep --no-peep-return 
PORT_FLAGS = --std-sdcc99 -mz80 -pz80 --sdcccall 1
EXTRA_CFLAGS  := $(PORT_FLAGS) --nostdinc -I. $(DEBUG_FLAGS)
EXTRA_LDFLAGS := $(PORT_FLAGS) --nostdlib --no-std-crt0

build: z80std.rel advantage_prom.rel cpmstd.rel

clean:
	rm -f *.lst *.rel *.sym

.asm.rel:
	sdasz80 -los $@ $<

.c.asm:
	sdcc --c1mode $< $(EXTRA_CFLAGS) $(CFLAGS)

PHONY: build clean
# end of file
