static BOOL kEnabled = TRUE;
static float kStiff = 300;
static float kDamp = 30;
static float kMass = 1;
static float kVelo = 20;
static float kDur = 1;

%hook CASpringAnimation

-(void)setStiffness:(double)arg1 {
	if(kEnabled){
		arg1 = kStiff;
	}
	%orig(arg1);
}

-(void)setDamping:(double)arg1 {
	if(kEnabled){
		arg1 = kDamp;
	}
	%orig(arg1);
}

-(void)setMass:(double)arg1 {
	if(kEnabled){
		arg1 = kMass;
	}
	%orig(arg1);
}

-(void)setVelocity:(double)arg1 {
	if(kEnabled){
		arg1 = kVelo;
	}
	%orig(arg1);
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

static void loadPrefs() {

       NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.shade.hortus.plist"];
    if(prefs)
    {
        kEnabled = ([prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : kEnabled);
				kStiff = ([prefs objectForKey:@"stiffness"] ? [[prefs objectForKey:@"stiffness"] floatValue] : kStiff);
				kDamp = ([prefs objectForKey:@"damping"] ? [[prefs objectForKey:@"damping"] floatValue] : kDamp);
				kMass = ([prefs objectForKey:@"mass"] ? [[prefs objectForKey:@"mass"] floatValue] : kMass);
				kVelo = ([prefs objectForKey:@"velocity"] ? [[prefs objectForKey:@"velocity"] floatValue] : kVelo);
				kDur = ([prefs objectForKey:@"duration"] ? [[prefs objectForKey:@"duration"] floatValue] : kDur);
    }
    [prefs release];
}

static void settingschanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
}

%ctor{

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingschanged, CFSTR("com.shade.hortus/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
