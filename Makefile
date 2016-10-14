# DESTDIR is used to install into a different root directory
DESTDIR?=/

all:
	iasl -ve -tc ssdt5.dsl
	mkdir -p kernel/firmware/acpi
	cp ssdt5.aml kernel/firmware/acpi
	find kernel | cpio -H newc --create > razer_acpi_fix.img

clean:
	@rm -f ssdt5.aml
	@rm -f ssdt5.hex
	@rm -f razer_acpi_fix.img
	@rm -rf kernel

install:
	mkdir -p "$(DESTDIR)/boot/"
	cp -f razer_acpi_fix.img "$(DESTDIR)/boot/razer_acpi_fix.img"

uninstall:
	rm -f "$(DESTDIR)/boot/razer_acpi_fix.img"
