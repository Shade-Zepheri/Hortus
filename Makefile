export TARGET = iphone:9.3
CFLAGS = -fobjc-arc

INSTALL_TARGET_PROCESSES = Preferences

ifneq ($(RESPRING),0)
INSTALL_TARGET_PROCESSES += SpringBoard
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Hortus
Hortus_FILES = Tweak.x

SUBPROJECTS = hortus

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
