
SDAS              ?=	sdasz80
DEFAULT_ASFLAGS   ?=	-glos

.SUFFIXES: .asm .rel

asm_rel_clean:
	rm -f *.lst
	rm -f *.rel
	rm -f *.sym

.asm.rel:
	${SDAS} -o ${DEFAULT_ASFLAGS} ${ASFLAGS} $@ $<

# vim: filetype=make
# end of file
