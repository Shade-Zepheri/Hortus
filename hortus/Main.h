#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#define HPrefsPath @"/User/Library/Preferences/com.shade.hortus.plist"
#define DPrefsPath @"/Library/PreferenceBundles/hortus.bundle/com.shade.hortus.plist"

@interface HORRootListController : PSListController
@end

@interface HOROptionsController : PSListController
@end

@interface HORAboutController : PSListController
@end
