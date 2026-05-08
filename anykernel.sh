### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=GrayRavens-Zenithed-V4-KWS-Ethereal-Community
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
ui_print " "
ui_print "  ================================="
ui_print "      GrayRavens // Zenithed V4    "
ui_print "  ================================="
ui_print " "
ui_print "    Kuchiba Chisa  x  ShadowbytePrjkt    "
ui_print "             Zenith On Top              "
ui_print "           By: andrei0514               "
ui_print " "
ui_print "  Onboarding the kernel..."
ui_print "  Patching the heart of zenith."
ui_print " "
ui_print "  Your phone has now been Zenithed."
ui_print "  Welcome aboard."
ui_print " "
# check kernel version
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
