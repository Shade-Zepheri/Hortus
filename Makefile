TARGET = iphone:clang:9.3
ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Hortus
Hortus_FILES = Tweak.xm
Hortus_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hortus
include $(THEOS_MAKE_PATH)/aggregate.mk
