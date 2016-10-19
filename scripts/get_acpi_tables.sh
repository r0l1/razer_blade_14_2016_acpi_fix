#!/bin/bash

set -e

DEST="./acpi_tables.tar.gz"
TMPDIR="/tmp/get_acpi_tables_tmp"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

mkdir -p "$TMPDIR"

# Extract DSDT.
cat "/sys/firmware/acpi/tables/DSDT" > "$TMPDIR/DSDT.dat"

# Extract SSDT Files.
SSDT_FILES=`ls /sys/firmware/acpi/tables/ | grep SSDT`
for f in $SSDT_FILES; do
    cat "/sys/firmware/acpi/tables/$f" > "$TMPDIR/$f.dat"
done

# Disassemble.
iasl -e "$TMPDIR"/*.dat -d "$TMPDIR"/*.dat

# Remove dat files.
rm "$TMPDIR"/*.dat

# Create final archive.
tar -czvf "$DEST" -C "$TMPDIR" .

# Cleanup.
rm -r "$TMPDIR"
