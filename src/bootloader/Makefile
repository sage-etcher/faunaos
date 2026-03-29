
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

PROG=	faunos-kernel
RELS=	crt0.rel \
     	bootloader.rel \
     	${EXTERNAL}/advantage_prom.rel \
     	${EXTERNAL}/z80std.rel

CFLAGS +=	-I$(EXTERNAL)

include ${MAKE_D_PATH}/sdcc.boot.mk
# vim: filetype=make
# end of file
