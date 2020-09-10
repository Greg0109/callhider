@interface TUCall
-(NSString *)name;
-(BOOL)isIncoming;
-(int)callStatus;
-(void)setShouldSuppressRingtone:(BOOL)arg1 ;
@end

@interface CXCall
-(BOOL)hasEnded;
@end

@interface SpringBoard
+(id)sharedApplication;
-(void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3;
-(void)applicationDidFinishLaunching:(id)arg1;
-(void)callhiderringer:(NSNotification *)notification;
-(void)_simulateLockButtonPress;
-(void)_simulateHomeButtonPress;
@end

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(id)init;
-(void)dealloc;
-(id)description;
-(unsigned long long)lockState;
-(void)_updateLockState;
-(BOOL)hasAnyLockState;
-(id)_descriptionForLockState:(unsigned long long)arg1 ;
@end


@interface SBRemoteAlertHandleServer
-(void)activate;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end

@interface SBVolumeControl
+(id)sharedInstance;
-(void)setVolume:(float)arg1 forCategory:(NSString *)arg1;
-(BOOL)_HUDIsDisplayableForCategory:(id)arg1 ;
-(void)toggleMute;
@end

NSArray *contactnamearray;
NSString *fakename;
NSString *realName;
NSDate *oldDate;
NSDate *newDate;
BOOL mask;
BOOL ringer;
BOOL hidecall;

%hook TUCall
-(NSString *)displayName {
  realName = %orig;
  NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.apple.springboard.plist"];
  if ([defaults[@"CallHider-Status"] boolValue]) {
    for (NSString *contact in contactnamearray) {
      if ([realName containsString:contact]) {
        if (mask) {
          realName = fakename;
        }
        if (ringer) {
          [self setShouldSuppressRingtone:YES];
        }
        return realName;
      }
    }
  }
  if (hidecall) {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CallHider-Show" object:nil userInfo:nil];
  }
  return realName;
}
%end

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)arg1 {
  if (hidecall) {
		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CallHider-Show" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
	    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
	      newDate = [NSDate date];
	      if ([newDate timeIntervalSinceDate:oldDate] > 3 || oldDate == nil) {
	        [self _simulateLockButtonPress];
	        oldDate = [NSDate date];
	      }
	    });
	  }];
	}
  %orig;
}
%end

%hook SBRemoteAlertHandleServer
-(void)activate {
  if (!hidecall) {
    %orig;
  }
}
%end

%ctor {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.callhiderprefs.plist"];
  BOOL enable = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : YES;
  mask = prefs[@"mask"] ? [prefs[@"mask"] boolValue] : YES;
  ringer = prefs[@"ringer"] ? [prefs[@"ringer"] boolValue] : NO;
  hidecall = prefs[@"hidecall"] ? [prefs[@"hidecall"] boolValue] : NO;
  NSString *contactname = prefs[@"contactname"] && !([prefs[@"contactname"] isEqualToString:@""]) ? [prefs[@"contactname"] stringValue] : @"contact name;contact name";
  contactnamearray = [contactname componentsSeparatedByString:@";"];
  fakename = prefs[@"fakename"] && !([prefs[@"fakename"] isEqualToString:@""]) ? [prefs[@"fakename"] stringValue] : @"Fake Name";
  if (enable) {
    %init();
  }
}
