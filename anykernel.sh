### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=GrayRavens
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot shell variables
BLOCK=boot;
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

# ---------------------------------------------------------------------------
# MillenniumTeam kernel check
# Abort installation if BOTH conditions are met:
#   1. Current kernel contains "MillenniumTeam"
#   2. Device is a MillenniumOSS-maintained device (CK7n, LH7n, LG7n, LG8n, X678B)
# This prevents flashing GrayRavens on MillenniumOSS ROMs.
# If only condition 1 is true (MillenniumTeam kernel on a non-MillenniumOSS
# device), installation proceeds — AnyKernel will overwrite it anyway.
# ---------------------------------------------------------------------------
if cat /proc/version | grep -q "MillenniumTeam"; then
    device=$(getprop ro.product.device)
    case "$device" in
        CK7n|LH7n|LG7n|LG8n|X678B)
            ui_print " "
            ui_print "  ╔════════════════════════════════════════════════╗"
            ui_print "  ║           ⚠️  INSTALLATION BLOCKED             ║"
            ui_print "  ╚════════════════════════════════════════════════╝"
            ui_print " "
            ui_print "  MillenniumTeam kernel has been found!"
            ui_print " "
            ui_print "  This means one of two things:"
            ui_print "  "
            ui_print "  1) You are installing this on a custom ROM"
            ui_print "     made by MillenniumOSS — this is STRICTLY"
            ui_print "     NOT ALLOWED."
            ui_print "  "
            ui_print "  2) You are using a MillenniumOSS kernel on a"
            ui_print "     device that MillenniumOSS maintains."
            ui_print "  "
            ui_print "  If you want to use GrayRavens, flash a different"
            ui_print "  kernel first (e.g. stock or any GKI-compatible"
            ui_print "  kernel), then retry."
            ui_print " "
            abort
            ;;
    esac
fi

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
ui_print " "
ui_print "  G R A Y R A V E N S"
ui_print "  G K I   K E R N E L"
ui_print " "
ui_print "  ────────────────────────────────────────────────"
ui_print " "
ui_print "   Loading kernel image........................ OK"
ui_print "   Setting up memory.......................... OK"
ui_print "   Initializing processor.................... OK"
ui_print "   Detecting hardware....................... OK"
ui_print "   Mounting system partitions.............. OK"
ui_print "   Verifying kernel integrity............... OK"
ui_print "   Starting init process..................... OK"
ui_print " "
ui_print "  ────────────────────────────────────────────────"
ui_print " "

# ---------------------------------------------------------------------------
# Kernel version check
# ---------------------------------------------------------------------------
kernel_version=$(cat /proc/version | awk -F '-' '{print $1}' | awk '{print $3}')
case "$kernel_version" in
    5.10.*) supp=true ;;
    *) supp=false ;;
esac
ui_print " " "-> 5.10 Kernel: $supp"
$supp || exit 1

# boot install
if [ -L "/dev/block/bootdevice/by-name/init_boot_a" -o -L "/dev/block/by-name/init_boot_a" ]; then
    split_boot # for devices with init_boot ramdisk
    flash_boot # for devices with init_boot ramdisk
else
    dump_boot # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk
    write_boot # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
fi

# ---------------------------------------------------------------------------
# OPLUS sepolicy for builds without KernelSU
#
# The /proc nodes need nothing here: the kernel marks them fs-internal, so the
# LSM hooks skip them on every variant. /data/nandswap is an ordinary file on
# /data and cannot be marked that way, so Magisk has to carry the rules. KSU
# builds get the same lines injected in-kernel and never reach this block.
# ---------------------------------------------------------------------------
if [ -d /data/adb/modules ]; then
    MODDIR=/data/adb/modules/grayravens_oplus
    rm -rf "$MODDIR"
    mkdir -p "$MODDIR"
    cat > "$MODDIR/module.prop" <<MODPROP
id=grayravens_oplus
name=GrayRavens OPLUS sepolicy
version=1
versionCode=1
author=GrayRavens
description=Let the vendor nandswap service use /data/nandswap without KernelSU.
MODPROP
    cat > "$MODDIR/sepolicy.rule" <<RULE
allow nandswap nandswap_file dir { create search write add_name }
allow nandswap nandswap_file file { create open read write getattr setattr }
allow init nandswap_file dir { create search write add_name }
allow vendor_init nandswap_file dir { create search }
RULE
    ui_print "  OPLUS sepolicy module installed........... OK"
fi

