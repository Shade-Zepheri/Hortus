#import "Hortus.h"
#import <Cephei/HBPreferences.h>

HBPreferences *preferences;
static BOOL enabled;
static BOOL senabled;
static BOOL appExempt = NO;
static BOOL sexempt;
static double stiff;
static double damp;
static double mass = 1;
static double velo = 20;
static double dur = 0.3;

%hook CASpringAnimation

-(void)setStiffness:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(enabled && senabled){
    arg1 = stiff;
    %orig(arg1);
  }else{
    %orig;
  }
}

-(void)setDamping:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(enabled && senabled){
    arg1 = damp;
    %orig(arg1);
  }else{
    %orig;
  }
}

-(void)setMass:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(enabled && senabled){
    arg1 = mass;
    %orig(arg1);
  }else{
    %orig;
  }
}

-(void)setVelocity:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(enabled && senabled){
    arg1 = velo;
    %orig(arg1);
  }else{
    %orig;
  }
}

%end

%hook CAAnimation

- (void)setDuration:(NSTimeInterval)duration {
	if(enabled){
		duration = duration * dur;
	}
	%orig(duration);
}

%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.shade.hortus"];
    [preferences registerDefaults:@{
        @"enabled": @YES,
        @"senabled": @YES,
        @"sexempt": @NO,
        @"stiff": @300,
        @"damp": @30,
        @"mass": @1,
        @"velo": @20,
        @"duration": @1,
    }];

    [preferences registerBool:&enabled default:NO forKey:@"enabled"];
    [preferences registerBool:&senabled default:NO forKey:@"senabled"];
    [preferences registerBool:&sexempt default:NO forKey:@"sexempt"];
    [preferences registerDouble:&stiff default:300 forKey:@"stiff"];
    [preferences registerDouble:&damp default:30 forKey:@"damp"];

}
