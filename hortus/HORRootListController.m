#import "Main.h"

@implementation HORRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Hortus" target:self];
	}

	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	CGRect frame = CGRectMake(0, 0, self.table.bounds.size.width, 127);

	UIImage *headerImage = [[UIImage alloc]
		initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/Hortus.bundle"] pathForResource:@"HortusHeader" ofType:@"png"]];

	UIImageView *headerView = [[UIImageView alloc] initWithFrame:frame];
	[headerView setImage:headerImage];
	headerView.backgroundColor = [UIColor blackColor];
	[headerView setContentMode:UIViewContentModeScaleAspectFit];
	[headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

	self.table.tableHeaderView = headerView;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	CGRect wrapperFrame = ((UIView *)self.table.subviews[0]).frame;
	CGRect frame = CGRectMake(wrapperFrame.origin.x, self.table.tableHeaderView.frame.origin.y, wrapperFrame.size.width, self.table.tableHeaderView.frame.size.height);

	self.table.tableHeaderView.frame = frame;
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

@end
