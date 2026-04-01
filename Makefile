
build clean:
	$(MAKE) -C src/external $@
	$(MAKE) -C src/cpmload  $@
	$(MAKE) -C src/boot-crt0 $@
	$(MAKE) -C src/hellorld $@


cleaner: clean
	rm -f compile_commands.json

disk_a.nsi: src/hellorld/hellorld_boot.bin
	./tools/extract_bootloader.sh $@ $<

test: disk_a.nsi
	-timeout 1 nsaectl quit
	nsae -psA $< &
	sleep 1
	./tools/lightmode
	nsaecli
	-timeout 1 nsaectl quit

PHONY: build clean cleaner test
# end of file
