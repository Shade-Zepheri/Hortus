#include "Main.h"

@implementation HOROptionsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Options" target:self];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notification = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notification) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notification, NULL, NULL, YES);
	}
}

- (void)resetSettings {
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:HPrefsPath error:&error];
	[[NSFileManager defaultManager] copyItemAtPath:DPrefsPath toPath:HPrefsPath error:&error];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR("com.shade.hortus/ReloadPrefs"),
                                       nil,
                                       nil,
                                       true);
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

@end
