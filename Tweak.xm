#define HPrefsPath @"/User/Library/Preferences/com.shade.hortus.plist"
static BOOL enabled = NO;
static BOOL senabled = NO;
static BOOL appExempt = NO;
static BOOL sexempt = NO;
static double stiff = 300;
static double damp = 30;
static double mass = 1;
static double velo = 20;
static double dur = 2;

static void initPrefs() {
	NSDictionary *HSettings = [NSDictionary dictionaryWithContentsOfFile:HPrefsPath];
  NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSString *settingsKeyPrefix = @"Exempt-";

      if ([[HSettings allKeys] containsObject:[NSString stringWithFormat:@"%@%@", settingsKeyPrefix, bundleID]]) {
        if ([[HSettings objectForKey:[NSString stringWithFormat:@"%@%@", settingsKeyPrefix, bundleID]] boolValue]) {
          appExempt =  YES;
        } else {
          appExempt =  NO;
        }
      }

	enabled = ([HSettings objectForKey:@"enabled"] ? [[HSettings objectForKey:@"enabled"] boolValue] : enabled);
  senabled = ([HSettings objectForKey:@"senabled"] ? [[HSettings objectForKey:@"senabled"] boolValue] : senabled);
  sexempt = ([HSettings objectForKey:@"sexempt"] ? [[HSettings objectForKey:@"sexempt"] boolValue] : sexempt);
  stiff = ([HSettings objectForKey:@"stiff"] ? [[HSettings objectForKey:@"stiff"] doubleValue] : stiff);
  damp = ([HSettings objectForKey:@"damp"] ? [[HSettings objectForKey:@"damp"] doubleValue] : damp);
  mass = ([HSettings objectForKey:@"mass"] ? [[HSettings objectForKey:@"mass"] doubleValue] : mass);
  velo = ([HSettings objectForKey:@"velo"] ? [[HSettings objectForKey:@"velo"] doubleValue] : velo);
  dur = ([HSettings objectForKey:@"duration"] ? [[HSettings objectForKey:@"duration"] doubleValue] : dur);

    if(sexempt){
      appExempt = YES;
    }else{
      appExempt = NO;
    }
}


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
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)initPrefs, CFSTR("com.shade.hortus/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	initPrefs();
}
