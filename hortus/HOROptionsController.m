#import "Main.h"

@implementation HOROptionsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Options" target:self];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *HSettings = [NSDictionary dictionaryWithContentsOfFile:HPrefsPath];
	if (!HSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return HSettings[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:HPrefsPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:HPrefsPath atomically:YES];
	CFStringRef HPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), HPost, NULL, NULL, YES);
}

- (void)resetSettings {
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:HPrefsPath error:&error];
	[[NSFileManager defaultManager] copyItemAtPath:DPrefsPath toPath:HPrefsPath error:&error];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.hortus/ReloadPrefs"), NULL, NULL, YES);
	if (!error) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Prefs Reset"
														 message:@"Preferences Were Reset Sucessfully."
														 preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
   	handler:^(UIAlertAction * action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
	} else {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
														 message:[NSString stringWithFormat:@"Error %@", [error localizedDescription]]
														 preferredStyle:UIAlertControllerStyleAlert];
	 [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
  	handler:^(UIAlertAction * action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
	}
}

- (void)showExplanation {

}

@end
