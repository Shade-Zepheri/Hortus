#import <Preferences/PSListController.h>
#include "HORRootListController.h"

@implementation HORRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Hortus" target:self];
	}

	return _specifiers;
}

- (id)bundle {
	return [NSBundle bundleForClass:[self class]];
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

- (void)github {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Shade-Zepheri/Hortus"]];
}

- (void)twitter {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/ShadeZepheri"]];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=ShadeZepheri"]];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=ShadeZepheri"]];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=ShadeZepheri"]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/ShadeZepheri"]];
	}
}

- (void)sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:ziroalpha@gmail.com?subject=Hortus"]];
}

@end
