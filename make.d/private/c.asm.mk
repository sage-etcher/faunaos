
SDCC           ?=	sdcc
DEFAULT_CFLAGS ?=	--std-sdcc99 -mz80 -pz80 --sdcccall 1 --nostdinc \
					--callee-saves --fomit-frame-pointer

CLEAN_ASM      ?=	y

.SUFFIXES: .c .asm

c_asm_clean:
	-[ "x${CLEAN_ASM}" == "xy" ] && rm -f *.asm
	rm -f *.asm.bak

.c.asm:
	${SDCC} -E $< ${DEFAULT_CFLAGS} ${CFLAGS} |\
		${SDCC} --c1mode -o $@ ${DEFAULT_CFLAGS} ${CFLAGS}
	cp -f $@ $@.bak

# vim: filetype=make
# end of file
