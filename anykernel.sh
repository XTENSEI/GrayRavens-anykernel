### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=GrayRavens-Zenithed-V1-Nova
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot shell variables
BLOCK=boot
IS_SLOT_DEVICE=1
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=auto

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

# banner
ui_print " "
ui_print "  ╔════════════════════════════════════════════╗"
ui_print "  ║                                            ║"
ui_print "  ║         ·  G R A Y R A V E N S  ·          ║"
ui_print "  ║                                            ║"
ui_print "  ║      ◢◤  S H A P I N G   G A P S  ◥◣       ║"
ui_print "  ║         「  Z E N I T H   V 1   」          ║"
ui_print "  ║                                            ║"
ui_print "  ║         ───  N O V A  ───                  ║"
ui_print "  ║      the kernel that bends boundaries      ║"
ui_print "  ║                                            ║"
ui_print "  ║    ✦  GrayRavens awakens the kernel  ✦     ║"
ui_print "  ║                                            ║"
ui_print "  ╚════════════════════════════════════════════╝"
ui_print " "
ui_print "           ショミー   ×   アンドレイ"
ui_print "              « Zenith On Top »"
ui_print "              ~ by andrei0514 ~"
ui_print " "
ui_print "  ────────────────────────────────────────────────"
ui_print " "

# kernel version
ui_print "- $(strings "${AKHOME}"/Image 2>/dev/null | grep -E -m1 'Linux version.*#' | awk '{print $3}')"

# boot install
split_boot
flash_boot
