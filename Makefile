TARGET = iphone:10.1
ARCHS = armv7 arm64
CFLAGS = -fobjc-arc -O2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Hortus
Hortus_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hortus
include $(THEOS_MAKE_PATH)/aggregate.mk
