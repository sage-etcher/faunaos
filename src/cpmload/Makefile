
MAKE_D_PATH=../../make.d
EXTERNAL=	../external

PROG=	cpmload
RELS=	cpmload.rel \
		${EXTERNAL}/z80std.rel \
		${EXTERNAL}/cpmstd.rel

CFLAGS +=	-DOS_CPM -I$(EXTERNAL)

include ${MAKE_D_PATH}/sdcc.cpm.mk
# vim: filetype=make
# end of file
