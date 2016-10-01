static BOOL kEnabled = YES;
static BOOL sEnabled = YES;
static BOOL appExempt = NO;
static BOOL sExempt = NO;
static double kStiff = 300;
static double kDamp = 30;
static double kMass = 1;
static double kVelo = 20;
static double kDur = 1;

%hook CASpringAnimation

-(void)setStiffness:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kStiff;
    %orig(arg1);
  }else{
    %orig;
  }
}

-(void)setDamping:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kDamp;
    %orig(arg1);
  }else{
    %orig(arg1);
  }
}

-(void)setMass:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kMass;
    %orig(arg1);
  }else{
    %orig(arg1);
  }
}

-(void)setVelocity:(double)arg1 {
  if(appExempt){
    %orig;
  }else if(kEnabled && sEnabled){
    arg1 = kVelo;
    %orig(arg1);
  }else{
    %orig(arg1);
  }
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
       NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
       NSString *settingsKeyPrefix = @"Exempt-";
    if(prefs)
    {
      if ([[prefs allKeys] containsObject:[NSString stringWithFormat:@"%@%@", settingsKeyPrefix, bundleID]]) {
        if ([[prefs objectForKey:[NSString stringWithFormat:@"%@%@", settingsKeyPrefix, bundleID]] boolValue]) {
          appExempt =  YES;
        } else {
          appExempt =  NO;
        }
      }

      kEnabled = ([prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : kEnabled);
      sEnabled = ([prefs objectForKey:@"senabled"] ? [[prefs objectForKey:@"senabled"] boolValue] : sEnabled);
			sExempt = ([prefs objectForKey:@"sexempt"] ? [[prefs objectForKey:@"sexempt"] boolValue] : sExempt);
			kStiff = ([prefs objectForKey:@"stiff"] ? [[prefs objectForKey:@"stiff"] doubleValue] : kStiff);
			kDamp = ([prefs objectForKey:@"damp"] ? [[prefs objectForKey:@"damp"] doubleValue] : kDamp);
			kMass = ([prefs objectForKey:@"mass"] ? [[prefs objectForKey:@"mass"] doubleValue] : kMass);
			kVelo = ([prefs objectForKey:@"velo"] ? [[prefs objectForKey:@"velo"] doubleValue] : kVelo);
			kDur = ([prefs objectForKey:@"duration"] ? [[prefs objectForKey:@"duration"] doubleValue] : kDur);

			if(sExempt){
				appExempt = YES;
			}else{
				appExempt = NO;
			}
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
