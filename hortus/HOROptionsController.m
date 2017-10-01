#import "HOROptionsController.h"

@implementation HOROptionsController

+ (NSString *)hb_specifierPlist {
		return @"Options";
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
		NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:HORPreferencePath];
		if (!settings[specifier.properties[@"key"]]) {
				return specifier.properties[@"default"];
		}
		return settings[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
		NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
		[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:HORPreferencePath]];
		[defaults setObject:value forKey:specifier.properties[@"key"]];
		[defaults writeToFile:HORPreferencePath atomically:YES];
		CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
		if (toPost) {
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
		}
}

- (void)resetSettings {
		NSError *error = nil;
		[[NSFileManager defaultManager] removeItemAtPath:HORPreferencePath error:&error];
		[[NSFileManager defaultManager] copyItemAtPath:HORBasePreferencesPath toPath:HORPreferencePath error:&error];
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.hortus/ReloadPrefs"), NULL, NULL, YES);
		if (!error) {
				UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Prefs Reset" message:@"Preferences Were Reset Sucessfully." preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
				[self presentViewController:alert animated:YES completion:nil];
		} else {
				UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Error %@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
				[self presentViewController:alert animated:YES completion:nil];
		}
}

- (void)showExplanation {

}

@end
