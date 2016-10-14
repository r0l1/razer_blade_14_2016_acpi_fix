# Razer Blade 14 2016 ACPI Firmware Fix

This repository contains an ACPI fix for the Razer Blade 14 2016.
If the discrete Nvidia GPU is switched off before starting Xorg or Wayland, then the system freezes.
The only possible solution is to manually disable/enable the discrete card after starting the graphical session.
With this SSDT fix the system works as expected and system lockups due to power settings of the discrete GPU are not more present.

## Installation

### Package Installation

- [Arch Linux AUR Package](https://aur.archlinux.org/packages/razer_blade_14_2016_acpi_fix-git/)

### Manual Installation

The build process requires `iasl` and `cpio`.

```
make all
sudo make install
```

This will compile and install the SSDT fix to the file `/boot/razer_acpi_fix.img`.

## Final Configuration

Lastly, configure the bootloader to load your CPIO archive. For example, using Systemd-boot, `/boot/loader/entries/arch.conf` might look like this:

```
title	 Arch Linux
linux	 /vmlinuz-linux
initrd   /razer_acpi_fix.img
initrd	 /initramfs-linux.img
options  root=PARTUUID=ec9d5998-a9db-4bd8-8ea0-35a45df04701 resume=PARTUUID=58d0aa86-d39b-4fe1-81cf-45e7add275a0 ...
```

Reboot and verify if the SSDT was overwritten:

```
$ dmesg | grep ACPI | grep override
[    0.000000] ACPI: Table Upgrade: override [SSDT-SaSsdt- SaSsdt ]
[    0.000000] ACPI: SSDT 0x000000003A882990 Physical table override, new table: 0x000000003A125000
```


# Hints

Always disassemble with externs included:

```
iasl -e *.dat -d SSDT5.dat
```

# Links

- https://www.kernel.org/doc/Documentation/acpi/initrd_table_override.txt
- https://wiki.archlinux.org/index.php/DSDT
