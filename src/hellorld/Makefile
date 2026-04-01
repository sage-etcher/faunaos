
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

CRT0_INC=	../boot-crt0
CRT0_REL=	../boot-crt0/crt0.rel

PROG=	hellorld
RELS=	${CRT0_REL} \
     	hellorld.rel \
     	${EXTERNAL}/advantage_prom.rel \
     	${EXTERNAL}/z80std.rel

CFLAGS +=	-I$(EXTERNAL) -I${CRT0_INC}

include ${MAKE_D_PATH}/sdcc.boot.mk
# vim: filetype=make
# end of file
