static BOOL enabled;
static float stiff;
static float damp;
static float mass;
static float velo;
static float dur;
#define settingsPath "com.shade.hortus"
#define postNotif "com.shade.hortus/settingschanged"

static void loadPrefs() {
    CFPreferencesAppSynchronize(CFSTR(settingsPath));
    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(settingsPath)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(settingsPath))) boolValue];
		stiff = !CFPreferencesCopyAppValue(CFSTR("stiff"), CFSTR(settingsPath)) ? 300 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("stiff"), CFSTR(settingsPath))) floatValue];
		damp = !CFPreferencesCopyAppValue(CFSTR("damp"), CFSTR(settingsPath)) ? 30 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("damp"), CFSTR(settingsPath))) floatValue];
		mass = !CFPreferencesCopyAppValue(CFSTR("mass"), CFSTR(settingsPath)) ? 1 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("mass"), CFSTR(settingsPath))) floatValue];
		velo = !CFPreferencesCopyAppValue(CFSTR("velo"), CFSTR(settingsPath)) ? 20 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("velo"), CFSTR(settingsPath))) floatValue];
		dur = !CFPreferencesCopyAppValue(CFSTR("dur"), CFSTR(settingsPath)) ? 1.0 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("dur"), CFSTR(settingsPath))) floatValue];
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
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR(postNotif),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}
