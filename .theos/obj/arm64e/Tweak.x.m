#line 1 "Tweak.x"
@interface TUCall
-(id)init;
-(NSString *)name;
-(BOOL)isIncoming;
-(int)callStatus;
-(void)setShouldSuppressRingtone:(BOOL)arg1 ;
@end

@interface CXCall
-(BOOL)hasEnded;
@end

@interface NCNotificationRequest
-(NSString *)sectionIdentifier;
-(id)sound;
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
NSArray *timeSlotArray;
NSString *fakename;
NSString *realName;
NSDate *oldDate;
NSDate *newDate;
BOOL mask;
BOOL ringer;
BOOL ringertime;
BOOL hidecall;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBRemoteAlertHandleServer; @class TUCall; @class NCNotificationRequest; @class SpringBoard; 
static NSString * (*_logos_orig$_ungrouped$TUCall$displayName)(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$TUCall$displayName(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBRemoteAlertHandleServer$activate)(_LOGOS_SELF_TYPE_NORMAL SBRemoteAlertHandleServer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBRemoteAlertHandleServer$activate(_LOGOS_SELF_TYPE_NORMAL SBRemoteAlertHandleServer* _LOGOS_SELF_CONST, SEL); 

#line 66 "Tweak.x"
static NSString * (*_logos_orig$ringertimeslots$NCNotificationRequest$sectionIdentifier)(_LOGOS_SELF_TYPE_NORMAL NCNotificationRequest* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$ringertimeslots$NCNotificationRequest$sectionIdentifier(_LOGOS_SELF_TYPE_NORMAL NCNotificationRequest* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$ringertimeslots$NCNotificationRequest$sound)(_LOGOS_SELF_TYPE_NORMAL NCNotificationRequest* _LOGOS_SELF_CONST, SEL); static id _logos_method$ringertimeslots$NCNotificationRequest$sound(_LOGOS_SELF_TYPE_NORMAL NCNotificationRequest* _LOGOS_SELF_CONST, SEL); 
static BOOL checkDate() {
  for (NSString *timeSlot in timeSlotArray) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSArray *hours = [timeSlot componentsSeparatedByString:@"-"];
    NSDate *startHour = [dateFormatter dateFromString:[hours objectAtIndex:0]];
    NSDate *endHour = [dateFormatter dateFromString:[hours objectAtIndex:1]];
    NSDate *currentHour = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    if (([currentHour compare:startHour] == NSOrderedDescending) && ([currentHour compare:endHour] == NSOrderedAscending)) {
      return YES;
    } else {
      continue;
    }
  }
  return NO;
}


static NSString * _logos_method$ringertimeslots$NCNotificationRequest$sectionIdentifier(_LOGOS_SELF_TYPE_NORMAL NCNotificationRequest* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  return _logos_orig$ringertimeslots$NCNotificationRequest$sectionIdentifier(self, _cmd);
}
static id _logos_method$ringertimeslots$NCNotificationRequest$sound(_LOGOS_SELF_TYPE_NORMAL NCNotificationRequest* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.greg0109.callhiderapplist"];
  if ([applist valueForKey:[self sectionIdentifier]] && checkDate()) {
    return nil;
  }
  return _logos_orig$ringertimeslots$NCNotificationRequest$sound(self, _cmd);
}




static NSString * _logos_method$_ungrouped$TUCall$displayName(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  realName = _logos_orig$_ungrouped$TUCall$displayName(self, _cmd);
  NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.apple.springboard.plist"];
  if (ringertime) {
    if (checkDate()) {
      NSLog(@"CallHider: Tweak is enabled");
      [defaults setValue:@"1" forKey:@"CallHider-Status"];
    } else {
      NSLog(@"CallHider: Tweak is disabled");
      [defaults setValue:@"0" forKey:@"CallHider-Status"];
    }
  }
  if ([defaults[@"CallHider-Status"] boolValue]) {
    for (NSString *contact in contactnamearray) {
      if ([realName containsString:contact]) {
        if (mask) {
          realName = fakename;
        }
        if (ringer) {
          if (ringertime && checkDate()) {
            NSLog(@"CallHider: Supress ringtone");
            [self setShouldSuppressRingtone:YES];
          } else if (!ringertime) {
            [self setShouldSuppressRingtone:YES];
          }
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



static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
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
  _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
}



static void _logos_method$_ungrouped$SBRemoteAlertHandleServer$activate(_LOGOS_SELF_TYPE_NORMAL SBRemoteAlertHandleServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  if (!hidecall) {
    _logos_orig$_ungrouped$SBRemoteAlertHandleServer$activate(self, _cmd);
  }
}


static __attribute__((constructor)) void _logosLocalCtor_a40d8748(int __unused argc, char __unused **argv, char __unused **envp) {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.callhiderprefs.plist"];
  BOOL enable = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : YES;
  mask = prefs[@"mask"] ? [prefs[@"mask"] boolValue] : YES;
  ringer = prefs[@"ringer"] ? [prefs[@"ringer"] boolValue] : NO;
  ringertime = prefs[@"ringertime"] ? [prefs[@"ringertime"] boolValue] : NO;
  hidecall = prefs[@"hidecall"] ? [prefs[@"hidecall"] boolValue] : NO;
  NSString *timeslot = prefs[@"timeslot"] && !([prefs[@"timeslot"] isEqualToString:@""]) ? [prefs[@"timeslot"] stringValue] : @"00:00-00:00";
  timeSlotArray = [timeslot componentsSeparatedByString:@";"];
  NSString *contactname = prefs[@"contactname"] && !([prefs[@"contactname"] isEqualToString:@""]) ? [prefs[@"contactname"] stringValue] : @"contact name;contact name";
  contactnamearray = [contactname componentsSeparatedByString:@";"];
  fakename = prefs[@"fakename"] && !([prefs[@"fakename"] isEqualToString:@""]) ? [prefs[@"fakename"] stringValue] : @"Fake Name";
  if (enable) {
    {Class _logos_class$_ungrouped$TUCall = objc_getClass("TUCall"); { MSHookMessageEx(_logos_class$_ungrouped$TUCall, @selector(displayName), (IMP)&_logos_method$_ungrouped$TUCall$displayName, (IMP*)&_logos_orig$_ungrouped$TUCall$displayName);}Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);}Class _logos_class$_ungrouped$SBRemoteAlertHandleServer = objc_getClass("SBRemoteAlertHandleServer"); { MSHookMessageEx(_logos_class$_ungrouped$SBRemoteAlertHandleServer, @selector(activate), (IMP)&_logos_method$_ungrouped$SBRemoteAlertHandleServer$activate, (IMP*)&_logos_orig$_ungrouped$SBRemoteAlertHandleServer$activate);}}
  }
  if (ringertime) {
    {Class _logos_class$ringertimeslots$NCNotificationRequest = objc_getClass("NCNotificationRequest"); { MSHookMessageEx(_logos_class$ringertimeslots$NCNotificationRequest, @selector(sectionIdentifier), (IMP)&_logos_method$ringertimeslots$NCNotificationRequest$sectionIdentifier, (IMP*)&_logos_orig$ringertimeslots$NCNotificationRequest$sectionIdentifier);}{ MSHookMessageEx(_logos_class$ringertimeslots$NCNotificationRequest, @selector(sound), (IMP)&_logos_method$ringertimeslots$NCNotificationRequest$sound, (IMP*)&_logos_orig$ringertimeslots$NCNotificationRequest$sound);}}
  }
}
