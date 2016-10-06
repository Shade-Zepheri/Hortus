include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = hortus
hortus_FILES = horRootListController.m
hortus_INSTALL_PATH = /Library/PreferenceBundles
hortus_FRAMEWORKS = UIKit
hortus_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
hortus_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/hortus.plist$(ECHO_END)
