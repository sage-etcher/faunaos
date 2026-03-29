
MAKE_D_PATH ?= ./make.d

DEFAULT_LDADD ?=	--std-sdcc99 -mz80 -pz80 --nostdlib --no-std-crt0 \
                	--xram-loc 0xc000 --xram-size 0x0800 --code-loc 0xc010

ORG_ADDR ?=	0xc000
FILETYPE ?=	bin
BLK_SIZE ?=	512

# spaces replaced with \x00 for real space use \x20
BOOT_HEADER ?= '\xc0         \xc3\x10\xc0   '

BUILD_DEPS += ${PROG}_boot.bin
CLEAN_DEPS += boot_clean

${PROG}_boot.bin: ${PROG}.bin
	cp $< .tmp.$@
	printf `printf '%s' ${BOOT_HEADER} | sed 's/ /\\\\x00/g'` |\
        dd of=.tmp.$@ bs=1 conv=notrunc status=none
	mv .tmp.$@ $@ 
	rm -f .tmp.$@

boot_clean:
	rm -f ${PROG}_boot.bin

include ${MAKE_D_PATH}/sdcc.bin.mk
# vim: filetype=make
# end of file
