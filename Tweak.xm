static BOOL enabled;
#define SETTINGSFILENEW "com.shade.hortus"
#define PREFERENCES_CHANGED_NOTIFICATION "com.shade.hortus/settingschanged"

static void iMoLoadPreferences() {
    CFPreferencesAppSynchronize(CFSTR(SETTINGSFILENEW));
    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(SETTINGSFILENEW))) boolValue];
}

static float kStiff = 300;
static float kDamp = 30;
static float kMass = 1;
static float kVelo = 20;
static float kDur = 1;

%hook SBLockScreenViewController
- (void)finishUIUnlockFromSource:(int)arg1 {
  %orig();
  if (enabled) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unlock" message:@"your device unlock finished ;)" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
      [alertView show];
  }
}
%end

%hook CASpringAnimation

-(void)setStiffness:(double)arg1 {
	if(enabled){
		arg1 = kStiff;
	}
	%orig(arg1);
}

-(void)setDamping:(double)arg1 {
	if(enabled){
		arg1 = kDamp;
	}
	%orig(arg1);
}

-(void)setMass:(double)arg1 {
	if(enabled){
		arg1 = kMass;
	}
	%orig(arg1);
}

-(void)setVelocity:(double)arg1 {
	if(enabled){
		arg1 = kVelo;
	}
	%orig(arg1);
}

%end

%hook CAAnimation

- (void)setDuration:(NSTimeInterval)duration {
	if(enabled){
		duration = duration * kDur;
	}
	%orig(duration);
}

%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)iMoLoadPreferences,
                                    CFSTR(PREFERENCES_CHANGED_NOTIFICATION),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
	iMoLoadPreferences();
}
