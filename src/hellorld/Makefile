
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

LDFLAGS +=	--xram-loc 0xc000 --xram-size 0x0800 --code-loc 0xc010
H2BFLAGS=	-e bin -m 512 -s 0xc000

PROG=	hellorld
RELS=	crt0.rel \
		hellorld.rel \
		${EXTERNAL}/advantage_prom.rel \
		${EXTERNAL}/z80std.rel

CFLAGS +=	-I$(EXTERNAL)

BUILD_DEPS += hellorld_boot.bin

hellorld_boot.bin: hellorld.bin
	cp $< .tmp.$@
	printf '\xc0'         |dd of=.tmp.$@ bs=1 seek=0  count=1 conv=notrunc status=none
	printf '\xc3\x10\xc0' |dd of=.tmp.$@ bs=1 seek=10 count=3 conv=notrunc status=none
	mv .tmp.$@ $@ 
	rm -f .tmp.$@

include ${MAKE_D_PATH}/sdcc.bin.mk
# vim: filetype=make
# end of file
