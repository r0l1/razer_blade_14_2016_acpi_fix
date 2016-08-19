# Razer Blade 14 2016 ACPI DSDT Fix

This repository contains an ACPI DSDT fix for the Razer Blade 14 2016.
If the discrete Nvidia GPU is switched off before starting Xorg or Wayland, then the system freezes.
The only possible solution is to manually disable/enable the discrete card after starting the graphical session.
With this DSDT fix the system works as expected and system lockups due to power settings of the discrete GPU are not more present.

## Installation

### Package Installation



### Manual Installation

The build process requires `iasl` and `cpio`.

```
make all
sudo make install
```

This will compile and install the DSDT fix to the file `/boot/acpi_override`.

## Final Configuration

Lastly, configure the bootloader to load your CPIO archive. For example, using Systemd-boot, `/boot/loader/entries/arch.conf` might look like this:

```
title	 Arch Linux
linux	 /vmlinuz-linux
initrd   /acpi_override
initrd	 /initramfs-linux.img
options  root=PARTUUID=ec9d5998-a9db-4bd8-8ea0-35a45df04701 resume=PARTUUID=58d0aa86-d39b-4fe1-81cf-45e7add275a0 ...
```

Reboot and verify if the DSDT was overwritten:

```
$ dmesg | grep ACPI | grep override
[    0.000000] ACPI: Table Upgrade: override [DSDT-ALASKA-  A M I ]
[    0.000000] ACPI: DSDT 0x000000003A85B228 Physical table override, new table: 0x000000003A106000
```
