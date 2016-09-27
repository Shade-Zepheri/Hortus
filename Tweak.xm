static BOOL enabled;
static float kStiff;
static float kDamp;
static float kMass;
static float kVelo;
static float kDur;
#define SETTINGSFILENEW "com.shade.hortus"
#define PREFERENCES_CHANGED_NOTIFICATION "com.shade.hortus/settingschanged"

static void iMoLoadPreferences() {
    CFPreferencesAppSynchronize(CFSTR(SETTINGSFILENEW));
    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(SETTINGSFILENEW))) boolValue];
		kStiff = !CFPreferencesCopyAppValue(CFSTR("stiff"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("stiff"), CFSTR(SETTINGSFILENEW))) floatValue];
		kDamp = !CFPreferencesCopyAppValue(CFSTR("damp"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("damp"), CFSTR(SETTINGSFILENEW))) floatValue];
		kMass = !CFPreferencesCopyAppValue(CFSTR("mass"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("mass"), CFSTR(SETTINGSFILENEW))) floatValue];
		kVelo = !CFPreferencesCopyAppValue(CFSTR("velo"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("velo"), CFSTR(SETTINGSFILENEW))) floatValue];
		kDur = !CFPreferencesCopyAppValue(CFSTR("dur"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("dur"), CFSTR(SETTINGSFILENEW))) floatValue];
}

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
