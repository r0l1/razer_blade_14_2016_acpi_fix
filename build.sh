#!/bin/sh

set -e

CURDIR="$PWD"
TMPDIR="$CURDIR/build"
IMAGEPATH="$CURDIR/razer_acpi_fix.img"

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
iasl -e "$TMPDIR"/*.dat -d "$TMPDIR"/SSDT5.dat

# Patch.
sed -i '/^ *External/! s/OSYS/0x07D9/g' "$TMPDIR/SSDT5.dsl"

# Compile.
iasl -ve -tc "$TMPDIR/SSDT5.dsl"

# Create the image.
mkdir -p "$TMPDIR/kernel/firmware/acpi"
cp "$TMPDIR/SSDT5.aml" "$TMPDIR/kernel/firmware/acpi/ssdt5.aml"
cd "$TMPDIR"
find kernel | cpio -H newc --create > "$IMAGEPATH"
cd "$CURDIR"

# Cleanup.
rm -r "$TMPDIR"
