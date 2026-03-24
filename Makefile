
build clean:
	$(MAKE) -C src/external $@
	$(MAKE) -C src/cpmload  $@
	$(MAKE) -C src/hellorld $@


cleaner: clean
	rm -f compile_commands.json

PHONY: build clean
# end of file
