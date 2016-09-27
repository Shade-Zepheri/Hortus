static BOOL enabled;
static float stiff = 300;
static float damp = 30;
static float mass = 1;
static float velo = 20;
static float dur;
#define SETTINGSFILENEW "com.shade.hortus"
#define PREFERENCES_CHANGED_NOTIFICATION "com.shade.hortus/settingschanged"

static void iMoLoadPreferences() {
    CFPreferencesAppSynchronize(CFSTR(SETTINGSFILENEW));
    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(SETTINGSFILENEW)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(SETTINGSFILENEW))) boolValue];
    dur = !CFPreferencesCopyAppValue(CFSTR("dur"), CFSTR(SETTINGSFILENEW)) ? 1.0 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("dur"), CFSTR(SETTINGSFILENEW))) floatValue];
}

%hook CASpringAnimation

-(void)setStiffness:(double)arg1 {
	if(enabled){
		arg1 = stiff;
	}
	%orig(arg1);
}

-(void)setDamping:(double)arg1 {
	if(enabled){
		arg1 = damp;
	}
	%orig(arg1);
}

-(void)setMass:(double)arg1 {
	if(enabled){
		arg1 = mass;
	}
	%orig(arg1);
}

-(void)setVelocity:(double)arg1 {
	if(enabled){
		arg1 = velo;
	}
	%orig(arg1);
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
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)iMoLoadPreferences,
                                    CFSTR(PREFERENCES_CHANGED_NOTIFICATION),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
	iMoLoadPreferences();
}
