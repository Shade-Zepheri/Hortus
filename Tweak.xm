#define HPrefsPath @"/User/Library/Preferences/com.shade.hortus.plist"
BOOL enabled = NO;
BOOL springEnabled = NO;
BOOL appExempt = NO;
CGFloat stiffness = 300;
CGFloat damping = 30;
CGFloat mass = 1;
CGFloat velocity = 20;
CGFloat durationMultiplier = 1;

void loadPrefs(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSDictionary *HSettings = [NSDictionary dictionaryWithContentsOfFile:HPrefsPath];
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

	if ([[HSettings objectForKey:@"SpringBoardOnly"] boolValue]) {
		if ([bundleID isEqualToString:@"com.apple.springboard"]) {
			appExempt = YES;
		}
	} else if ([[HSettings objectForKey:[NSString stringWithFormat:@"Exempt-%@", bundleID]] boolValue]) {
		appExempt = YES;
	} else {
		appExempt = NO;
	}

	enabled = ([HSettings objectForKey:@"enabled"] ? [[HSettings objectForKey:@"enabled"] boolValue] : enabled);
  springEnabled = ([HSettings objectForKey:@"springEnabled"] ? [[HSettings objectForKey:@"springEnabled"] boolValue] : springEnabled);
  stiffness = ([HSettings objectForKey:@"stiffness"] ? [[HSettings objectForKey:@"stiffness"] floatValue] : stiffness);
  damping = ([HSettings objectForKey:@"damping"] ? [[HSettings objectForKey:@"damping"] floatValue] : damping);
  mass = ([HSettings objectForKey:@"mass"] ? [[HSettings objectForKey:@"mass"] floatValue] : mass);
  velocity = ([HSettings objectForKey:@"velocity"] ? [[HSettings objectForKey:@"velocity"] floatValue] : velocity);
  durationMultiplier = ([HSettings objectForKey:@"multiplier"] ? [[HSettings objectForKey:@"multiplier"] floatValue] : durationMultiplier);
}

%hook CASpringAnimation
- (void)setStiffness:(CGFloat)arg1 {
  if (appExempt) {
    %orig;
  } else if (enabled && springEnabled) {
    %orig(stiffness);
  } else {
    %orig;
  }
}

- (void)setDamping:(CGFloat)arg1 {
  if (appExempt) {
    %orig;
  } else if (enabled && springEnabled) {
    %orig(damping);
  } else {
    %orig;
  }
}

- (void)setMass:(CGFloat)arg1 {
  if (appExempt) {
    %orig;
  } else if (enabled && springEnabled) {
    arg1 = mass;
    %orig(arg1);
  } else {
    %orig;
  }
}

- (void)setVelocity:(CGFloat)arg1 {
  if (appExempt) {
    %orig;
  } else if (enabled && springEnabled) {
    %orig(velocity);
  } else {
    %orig;
  }
}
%end

%hook CAAnimation
- (void)setDuration:(NSTimeInterval)duration {
	if (enabled) {
		duration = duration * durationMultiplier;
	}
	%orig(duration);
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &loadPrefs, CFSTR("com.shade.hortus/ReloadPrefs"), NULL, 0);
	loadPrefs(nil, nil, nil, nil, nil);
}
