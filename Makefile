# DESTDIR is used to install into a different root directory
DESTDIR?=/

all:
	./build.sh

clean:
	@rm -f razer_acpi_fix.img
	@rm -rf build

install:
	mkdir -p "$(DESTDIR)/boot/"
	cp -f razer_acpi_fix.img "$(DESTDIR)/boot/razer_acpi_fix.img"

uninstall:
	rm -f "$(DESTDIR)/boot/razer_acpi_fix.img"
