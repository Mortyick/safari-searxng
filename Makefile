export SDKVERSION = 16.5
export ARCHS = arm64 arm64e

THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = MobileSafari

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = searxng

searxng_FILES = Tweak.x
searxng_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
