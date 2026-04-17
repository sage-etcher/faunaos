CFLAGS = --std-sdcc99 -mz80 -pz80 --sdcccall 1 --nostdinc \
		 --callee-saves --fomit-frame-pointer

LDADD = --std-sdcc99 -mz80 -pz80 --nostdlib --no-std-crt0 \
		--code-loc 0x0100

build: main.bin

clean:
	rm -f main.asm

	rm -f main.lst
	rm -f main.rel
	rm -f main.sym
	rm -f main.rel

	rm -f main.lk
	rm -f main.map
	rm -f main.noi
	rm -f main.ihx

	rm -f main.bin

main.bin: main.ihx
	hex2bin -e bin -m 512 -s 0x0100 $<
	
main.ihx: main.rel
	sdcc -o $@ $^ ${LDADD}

main.rel: main.asm
	sdasz80 -glos $@ $<

main.asm: main.c
	sdcc -E $< ${CFLAGS} |\
		sdcc --c1mode -o $@ ${CFLAGS}

# vim: noet
# end of file
