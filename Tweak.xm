BOOL enabled;
BOOL springEnabled;
BOOL appExempt = NO;
CGFloat stiffness;
CGFloat damping;
CGFloat mass;
CGFloat velocity;
CGFloat durationMultiplier;

void loadPrefs() {
	NSDictionary *HSettings = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.shade.hortus.plist"];
	NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;

	if ([[HSettings objectForKey:@"SpringBoardOnly"] boolValue]) {
		if (![bundleID isEqualToString:@"com.apple.springboard"]) {
			appExempt = YES;
		}
	} else if ([[HSettings objectForKey:[NSString stringWithFormat:@"Exempt-%@", bundleID]] boolValue]) {
		appExempt = YES;
	} else {
		appExempt = NO;
	}

	enabled = ![HSettings objectForKey:@"enabled"] ? NO : [[HSettings objectForKey:@"enabled"] boolValue];
  springEnabled = ![HSettings objectForKey:@"springEnabled"] ? NO : [[HSettings objectForKey:@"springEnabled"] boolValue];
  stiffness = ![HSettings objectForKey:@"stiffness"] ? 300 : [[HSettings objectForKey:@"stiffness"] floatValue];
  damping = ![HSettings objectForKey:@"damping"] ? 30 : [[HSettings objectForKey:@"damping"] floatValue];
  mass = ![HSettings objectForKey:@"mass"] ? 1 : [[HSettings objectForKey:@"mass"] floatValue];
  velocity = ![HSettings objectForKey:@"velocity"] ? 20 : [[HSettings objectForKey:@"velocity"] floatValue];
  durationMultiplier = ![HSettings objectForKey:@"multiplier"] ? 1 : [[HSettings objectForKey:@"multiplier"] floatValue];
}

%hook CASpringAnimation
- (void)setStiffness:(CGFloat)arg1 {
	if (enabled && springEnabled && !appExempt) {
    %orig(stiffness);
  } else {
    %orig;
  }
}

- (void)setDamping:(CGFloat)arg1 {
	if (enabled && springEnabled && !appExempt) {
    %orig(damping);
  } else {
    %orig;
  }
}

- (void)setMass:(CGFloat)arg1 {
	if (enabled && springEnabled && !appExempt) {
    %orig(mass);
  } else {
    %orig;
  }
}

- (void)setVelocity:(CGFloat)arg1 {
	if (enabled && springEnabled && !appExempt) {
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
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.shade.hortus/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}
