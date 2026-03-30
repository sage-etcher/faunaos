
.SUFFIXES:

MAKE_D_PATH ?= ./make.d

#RELS       =	foo.rel
#ASFLAGS   +=	
#CFLAGS    +=	

build: ${RELS} ${BUILD_DEPS}

clean: c_asm_clean asm_rel_clean ${CLEAN_DEPS}

include ${MAKE_D_PATH}/private/c.asm.mk
include ${MAKE_D_PATH}/private/asm.rel.mk
# vim: filetype=make
# end of file
