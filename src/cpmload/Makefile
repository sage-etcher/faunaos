
.SUFFIXES: .c .rel

EXTERNAL = ../external

OS_FLAG = -DOS_CPM
#OS_FLAG = -DOS_NSDOS
#OS_FLAG = -DOS_BARE
PORT_FLAGS = --std-sdcc99 -mz80 -pz80 --sdcccall 1
EXTRA_CFLAGS  := $(PORT_FLAGS) --nostdinc -I. -I$(EXTERNAL) $(OS_FLAG)
EXTRA_LDFLAGS := $(PORT_FLAGS) --nostdlib --no-std-crt0

build: cpmload.com

clean:
	rm -f *.asm *.lst *.rel *.sym   # build artifacts
	rm -f *.ihx *.lk *.map *.noi    # link artifacts 
	rm -f .tmp.*                    # temporary build files
	rm -f cpmload.com

# cpmload
.c.rel:
	sdcc -c $< $(EXTRA_CFLAGS) $(CFLAGS)

cpmload.ihx: cpmload.rel $(EXTERNAL)/z80std.rel $(EXTERNAL)/cpmstd.rel
	sdcc $^ $(EXTRA_LDFLAGS) $(LDFLAGS) --code-loc 0x0100 --data-loc 0x1000
		#--code-loc 0x0100 --code-size 0x0e00 \
		#--data-loc 0x1000 --stack-loc 0x1000

cpmload.com: cpmload.ihx
	hex2bin -e com -m 0x080 -s 0x0100 $< >/dev/null

PHONY: build clean
# end of file
