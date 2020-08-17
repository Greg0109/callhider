@interface SBVolumeControl
+(id)sharedInstance;
-(void)setVolume:(float)arg1 forCategory:(NSString *)arg1;
-(BOOL)_HUDIsDisplayableForCategory:(id)arg1 ;
-(void)toggleMute;
@end

@interface SpringBoard
+(id)sharedApplication;
-(void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3;
@end

NSArray *contactnamearray;
NSString *fakename;
BOOL mask;
BOOL ringer;
/*%hook TUCall
- (NSString *)displayName {
    return @"Penis";
}
%end

%hook TUCall
- (NSString *)displayFirstName {
    return @"Fire";
}
%end*/

%hook TUCallDisplayContext
- (NSString *)name {
  NSString *realName = %orig;
  for (NSString *contact in contactnamearray) {
    if ([realName containsString:contact]) {
      if (mask) {
        realName = fakename;
      }
      if (ringer) {
        SpringBoard *springboard = [%c(SpringBoard) sharedApplication];
        [springboard _updateRingerState:0 withVisuals:YES updatePreferenceRegister:YES];
      }
      break;
    }
  }
  return realName;
}
%end

%ctor {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.callhiderprefs.plist"];
  BOOL enable = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : YES;
  mask = prefs[@"mask"] ? [prefs[@"mask"] boolValue] : YES;
  ringer = prefs[@"ringer"] ? [prefs[@"ringer"] boolValue] : NO;
  NSString *contactname = prefs[@"contactname"] && !([prefs[@"contactname"] isEqualToString:@""]) ? [prefs[@"contactname"] stringValue] : @"contact name;contact name";
  contactnamearray = [contactname componentsSeparatedByString:@";"];
  fakename = prefs[@"fakename"] && !([prefs[@"fakename"] isEqualToString:@""]) ? [prefs[@"fakename"] stringValue] : @"Fake Name";
  if (enable) {
    %init();
  }
}
