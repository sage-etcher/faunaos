
MAKE_D_PATH ?= ./make.d

#RELS       =	foo.rel
#ASFLAGS   +=	
#CFLAGS    +=	

build: ${RELS}

clean: c_asm_clean asm_rel_clean

include ${MAKE_D_PATH}/private/c.asm.mk
include ${MAKE_D_PATH}/private/asm.rel.mk
# vim: filetype=make
# end of file
