TARGET = iphone:9.2
CFLAGS = -fobjc-arc -O2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Hortus
Hortus_FILES = HORRootListController.m HOROptionsController.m HORAboutController.m
Hortus_INSTALL_PATH = /Library/PreferenceBundles
Hortus_FRAMEWORKS = UIKit
Hortus_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Hortus.plist$(ECHO_END)
