
ORG_ADDR ?=	0x0000
FILETYPE ?=	bin
BLK_SIZE ?= 512

#PROG=
PROG_IHX ?= ${PROG}.ihx
PROG_BIN ?= ${PROG}.${FILETYPE}

HEX2BIN          ?=	hex2bin
DEFAULT_H2BFLAGS ?=	-e ${FILETYPE} -m ${BLK_SIZE} -s ${ORG_ADDR}

ihx_bin_clean:
	rm -f ${PROG_BIN}

${PROG_BIN}: ${PROG_IHX}
	${HEX2BIN} ${DEFAULT_H2BFLAGS} ${H2BFLAGS} $< >/dev/null

# vim: filetype=make
# end of file
