
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

CLEAN_ASM=	n
PROG=	hellorld
RELS=	crt0.rel \
     	hellorld.rel \
     	${EXTERNAL}/advantage_prom.rel \
     	${EXTERNAL}/z80std.rel

CLEAN_DEPS +=	clean_specific_asm

CFLAGS +=	-I$(EXTERNAL)

clean_specific_asm:
	rm -f hellorld.asm

include ${MAKE_D_PATH}/sdcc.boot.mk
# vim: filetype=make
# end of file
