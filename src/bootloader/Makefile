
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

CLEAN_ASM=	n
CRT0_INC=	../boot-crt0
CRT0_REL=	../boot-crt0/crt0.rel

PROG=	bootloader
RELS=	crt0.rel \
     	bios.rel \
     	${EXTERNAL}/advantage_prom.rel \
     	${EXTERNAL}/z80std.rel \
     	bootloader.rel \

CFLAGS +=	-I${EXTERNAL}

CLEAN_DEPS +=	custom_clean

all: build

custom_clean:
	rm -f bootloader.asm.bak

include ${MAKE_D_PATH}/sdcc.boot.mk
# vim: filetype=make
# end of file
