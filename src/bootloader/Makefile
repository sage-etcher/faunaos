
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

CLEAN_ASM=	n
CRT0_INC=	../boot-crt0
CRT0_REL=	../boot-crt0/crt0.rel

>>>>>>> 2426cf0 (start on floppy_driver)
PROG=	faunos-kernel
RELS=	${CRT0_REL} \
     	bootloader.rel \
     	floppy_driver.rel \
     	${EXTERNAL}/advantage_prom.rel \
     	${EXTERNAL}/z80std.rel

CFLAGS +=	-I${EXTERNAL} -I${CRT0_INC}

CLEAN_DEPS +=	custom_clean

custom_clean:
	rm -f bootloader.asm

include ${MAKE_D_PATH}/sdcc.boot.mk
# vim: filetype=make
# end of file
