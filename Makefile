all:
	iasl -tc dsdt.dsl
	mkdir -p kernel/firmware/acpi
	cp dsdt.aml kernel/firmware/acpi
	find kernel | cpio -H newc --create > acpi_override

clean:
	@rm -f dsdt.aml
	@rm -f dsdt.hex
	@rm -f acpi_override
	@rm -rf kernel

install:
	cp -f acpi_override /boot/acpi_override

uninstall:
	rm -f /boot/acpi_override
