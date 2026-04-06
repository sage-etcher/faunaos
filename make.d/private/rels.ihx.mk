
#PROG_IHX=	out.ihx
#RELS=		in0.rel in1.rel in2.rel

PROG_IHX ?= ${PROG}.ihx

SDCC          ?=	sdcc
DEFAULT_LDADD ?=	--std-sdcc99 -mz80 -pz80 --nostdlib --no-std-crt0 \
                	--code-loc ${ORG_ADDR}

rels_ihx_clean:
	rm -f ${PROG_IHX}
	rm -f *.lk
	rm -f *.map
	rm -f *.noi

${PROG_IHX}: ${RELS}
	${SDCC} -o $@ $^ ${DEFAULT_LDADD} ${LDADD}

# vim: filetype=make
# end of file
