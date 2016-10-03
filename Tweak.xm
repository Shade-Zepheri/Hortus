#import "Hortus.h"
#import <Cephei/HBPreferences.h>

HBPreferences *preferences;
static BOOL kEnabled;
static BOOL sEnabled;
static BOOL appExempt;
static BOOL sExempt;
static double kStiff;
static double kDamp;
static double kMass;
static double kVelo;
static double kDur;

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%hook CASpringAnimation

-(void)setStiffness:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kStiff;
    %orig(arg1);
  }else{
    %orig;
  }
}

-(void)setDamping:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kDamp;
    %orig(arg1);
  }else{
    %orig(arg1);
  }
}

-(void)setMass:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kMass;
    %orig(arg1);
  }else{
    %orig(arg1);
  }
}

-(void)setVelocity:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kVelo;
    %orig(arg1);
  }else{
    %orig(arg1);
  }
}

%end

%hook CAAnimation

- (void)setDuration:(NSTimeInterval)duration {
	if(kEnabled){
		duration = duration * kDur;
	}
	%orig(duration);
}

%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.shade.ctest"];
    [preferences registerDefaults:@{
        @"enabled": @NO,
        @"senabled": @NO,
        @"sexempt": @NO,
        @"stiff": @300,
        @"damp": @30,
        @"mass": @1,
        @"velo": @20,
        @"duration": @1,
    }];

    [preferences registerBool:&kEnabled default:NO forKey:@"enabled"];
    [preferences registerBool:&sEnabled default:NO forKey:@"senabled"];
    [preferences registerBool:&sExempt default:NO forKey:@"sexempt"];
    [preferences registerDouble:&kStiff default:20 forKey:@"stiff"];
    [preferences registerDouble:&kDamp default:20 forKey:@"damp"];
    [preferences registerDouble:&kMass default:20 forKey:@"mass"];
    [preferences registerDouble:&kVelo default:20 forKey:@"velo"];
    [preferences registerDouble:&kDur default:20 forKey:@"duration"];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        &respring,
                                        CFSTR("RESPRING"),
                                        NULL,
                                        0);
}
