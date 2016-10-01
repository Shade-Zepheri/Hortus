export THEOS_DEVICE_IP=192.168.254.10

TARGET = iphone:clang:9.3
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = Hortus
Hortus_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hortus
include $(THEOS_MAKE_PATH)/aggregate.mk
