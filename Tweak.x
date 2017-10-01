static BOOL enabled;
static BOOL springEnabled;
static BOOL appExempt = NO;
static CGFloat stiffness;
static CGFloat damping;
static CGFloat mass;
static CGFloat velocity;
static CGFloat durationMultiplier;

static void reloadSettings() {
		NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.shade.hortus.plist"];
		NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;

		if ([[settings objectForKey:@"SpringBoardOnly"] boolValue] && IN_SPRINGBOARD) {
				appExempt = YES;
		} else if ([[settings objectForKey:[NSString stringWithFormat:@"Exempt-%@", bundleIdentifier]] boolValue]) {
				appExempt = YES;
		} else {
				appExempt = NO;
		}

		enabled = ![settings objectForKey:@"enabled"] ? NO :[[settings objectForKey:@"enabled"] boolValue];
		springEnabled = ![settings objectForKey:@"springEnabled"] ? NO :[[settings objectForKey:@"springEnabled"] boolValue];
		stiffness = ![settings objectForKey:@"stiffness"] ? 300 :[[settings objectForKey:@"stiffness"] floatValue];
		damping = ![settings objectForKey:@"damping"] ? 30 :[[settings objectForKey:@"damping"] floatValue];
		mass = ![settings objectForKey:@"mass"] ? 1 :[[settings objectForKey:@"mass"] floatValue];
		velocity = ![settings objectForKey:@"velocity"] ? 20 :[[settings objectForKey:@"velocity"] floatValue];
		durationMultiplier = ![settings objectForKey:@"multiplier"] ? 1 :[[settings objectForKey:@"multiplier"] floatValue];
}

%hook CASpringAnimation
- (void)setStiffness: (CGFloat)value {
		if (enabled && springEnabled && !appExempt) {
				value = stiffness;
		}

		%orig(value);
}

- (void)setDamping:(CGFloat)value {
		if (enabled && springEnabled && !appExempt) {
				value = damping;
		}

		%orig(value);
}

- (void)setMass:(CGFloat)value {
		if (enabled && springEnabled && !appExempt) {
				value = mass;
		}

		%orig(value);
}

- (void)setVelocity:(CGFloat)value {
		if (enabled && springEnabled && !appExempt) {
				value = velocity;
		}

		%orig(value);
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
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.shade.hortus/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		reloadSettings();
}
