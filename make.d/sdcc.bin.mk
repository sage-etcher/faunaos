
.SUFFIXES:

MAKE_D_PATH ?= ./make.d

#PROG       =   foo
#RELS       =	foo.rel
#ASFLAGS   +=	
#CFLAGS    +=	
#LDADD      =	

PROG_BIN ?= ${PROG}.bin

ORG_ADDR ?=	0x0000
FILETYPE ?=	bin
BLK_SIZE ?=	512

build: ${PROG_BIN} ${BUILD_DEPS}

clean: c_asm_clean asm_rel_clean rels_ihx_clean ihx_bin_clean ${CLEAN_DEPS}

include ${MAKE_D_PATH}/private/c.asm.mk
include ${MAKE_D_PATH}/private/asm.rel.mk
include ${MAKE_D_PATH}/private/rels.ihx.mk
include ${MAKE_D_PATH}/private/ihx.bin.mk
# vim: filetype=make
# end of file
