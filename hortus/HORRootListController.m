#import "HORRootListController.h"

@implementation HORRootListController

+ (NSString *)hb_specifierPlist {
    return @"Hortus";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = CGRectMake(0, 0, [self table].bounds.size.width, 127);

    UIImage *headerImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/Hortus.bundle"] pathForResource:@"HortusHeader" ofType:@"png"]];

    UIImageView *headerView = [[UIImageView alloc] initWithFrame:frame];
    headerView.image = headerImage;
    headerView.backgroundColor = [UIColor blackColor];
    headerView.contentMode = UIViewContentModeScaleAspectFit;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self table].tableHeaderView = headerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect wrapperFrame = ((UIView *)[self table].subviews[0]).frame;
    CGRect frame = CGRectMake(wrapperFrame.origin.x, [self table].tableHeaderView.frame.origin.y, wrapperFrame.size.width, [self table].tableHeaderView.frame.size.height);

    [self table].tableHeaderView.frame = frame;
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

@end
