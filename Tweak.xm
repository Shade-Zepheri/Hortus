static BOOL kEnabled = YES;
static BOOL sEnabled = YES;
static BOOL appExempt = NO;
static float kStiff = 300;
static float kDamp = 30;
static float kMass = 1;
static float kVelo = 20;
static float kDur = 1;

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
			kStiff = ([prefs objectForKey:@"stiff"] ? [[prefs objectForKey:@"stiff"] floatValue] : kStiff);
			kDamp = ([prefs objectForKey:@"damp"] ? [[prefs objectForKey:@"damp"] floatValue] : kDamp);
			kMass = ([prefs objectForKey:@"mass"] ? [[prefs objectForKey:@"mass"] floatValue] : kMass);
			kVelo = ([prefs objectForKey:@"velo"] ? [[prefs objectForKey:@"velo"] floatValue] : kVelo);
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
