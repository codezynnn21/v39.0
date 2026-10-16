#!/system/bin/sh
# Runs inside Magisk / Kitsune Magisk / KernelSU / SukiSU / APatch installers.
SKIPUNZIP=0
ui_print "- CODM Blocky Textures"
ui_print "- Needs Zygisk (Magisk: Settings > Zygisk ON, or ZygiskNext on KernelSU/APatch)"

# arm64 and 32-bit arm (armeabi-v7a) are both supported from v0.38.
case "$ARCH" in
  arm64|arm) ;;
  *)
    # KernelSU / APatch may report ARCH differently; only abort on pure Magisk when clearly unsupported.
    if [ -z "$KSU" ] && [ -z "$APATCH" ]; then
      abort "! Only arm / arm64 phones are supported (this device: $ARCH)"
    fi
    ;;
esac

HAVE64=0
HAVE32=0
[ -f "$MODPATH/zygisk/arm64-v8a.so" ] && HAVE64=1
[ -f "$MODPATH/zygisk/armeabi-v7a.so" ] && HAVE32=1

if [ "$HAVE64" = "0" ] && [ "$HAVE32" = "0" ]; then
  abort "! No zygisk/*.so in this zip (need arm64-v8a and/or armeabi-v7a). Re-download the module."
fi

if [ "$ARCH" = "arm64" ] && [ "$HAVE64" = "0" ]; then
  ui_print "! Warning: arm64 device but zygisk/arm64-v8a.so missing — 32-bit so will not load in 64-bit CODM."
fi
if [ "$ARCH" = "arm" ] && [ "$HAVE32" = "0" ]; then
  ui_print "! Warning: 32-bit device but zygisk/armeabi-v7a.so missing."
fi

ui_print "- ABI package: arm64=$HAVE64 arm32=$HAVE32"
ui_print "- Settings UI: KernelSU/SukiSU/APatch open it from the manager."
ui_print "  Magisk has no built-in WebUI: use KsuWebUI or MMRL to open this module's page."
ui_print "- Reboot, then open CODM once (until the lobby). The module writes codm_tex.status there."
ui_print "  If the WebUI later says the module never ran: check Zygisk is ON and CODM is not on the DenyList."
ui_print "- Login/loading protected: render scale and texture edits wait for the start-delay window."
