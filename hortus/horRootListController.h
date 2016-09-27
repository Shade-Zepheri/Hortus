#import <Preferences/PSListController.h>

@interface horRootListController : PSListController {
  NSMutableDictionary *prefs;
  NSArray *directoryContent;
}
  - (NSArray *)getValues:(id)target;
  - (void)previewAndSet:(id)value forSpecifier:(id)specifier;

@end
