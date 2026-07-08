export SDKVERSION = 16.5
export ARCHS = arm64 arm64e

THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = MobileSafari

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 4get

4get_FILES = Tweak.x
4get_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
