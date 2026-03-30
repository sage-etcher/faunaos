
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

CLEAN_ASM=	n
PROG=	faunos-kernel
RELS=	crt0.rel \
     	bootloader.rel \
     	${EXTERNAL}/advantage_prom.rel \
     	${EXTERNAL}/z80std.rel

CFLAGS +=	-I$(EXTERNAL)

CLEAN_DEPS +=	custom_clean

custom_clean:
	rm -f bootloader.asm

include ${MAKE_D_PATH}/sdcc.boot.mk
# vim: filetype=make
# end of file
