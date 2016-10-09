#include "horRootListController.h"

@implementation horRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Hortus" target:self] retain];
	}

	return _specifiers;
}

-(id) bundle {
	return [NSBundle bundleForClass:[self class]];
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *HSettings = [NSDictionary dictionaryWithContentsOfFile:HPrefsPath];
	if (!HSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return HSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:HPrefsPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:HPrefsPath atomically:YES];
	CFStringRef HPost = (CFStringRef)specifier.properties[@"PostNotification"];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), HPost, NULL, NULL, YES);
}

-(void) resetSettings {
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:HPrefsPath error:&error];
	[[NSFileManager defaultManager] copyItemAtPath:DPrefsPath toPath:HPrefsPath error:&error];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR("com.shade.hortus/ReloadPrefs"),
                                       nil,
                                       nil,
                                       true);
	if (!error) {
	    UIAlertView *resetSettingsDiag = [[UIAlertView alloc] initWithTitle:@"Prefs Reset"
													message:@"Preferences were reset sucessfully"
													delegate:nil
													cancelButtonTitle:@"Ok"
													otherButtonTitles: nil];
		[resetSettingsDiag show];
	} else {
		UIAlertView *resetSettingsDiag = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[NSString stringWithFormat:@"Error %@", [error localizedDescription]]
													delegate:nil
													cancelButtonTitle:@"Ok"
													otherButtonTitles: nil];
		[resetSettingsDiag show];
	}
}

-(void) sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:ziroalpha@gmail.com?subject=Hortus"]];
}

@end
