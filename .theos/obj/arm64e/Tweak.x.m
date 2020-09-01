#line 1 "Tweak.x"
@interface TUCall
-(NSString *)name;
-(BOOL)isIncoming;
-(int)callStatus;
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

@class SpringBoard; @class SBRemoteAlertHandleServer; @class SBLockStateAggregator; @class TUCall; 
static NSString * (*_logos_orig$_ungrouped$TUCall$displayName)(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$TUCall$displayName(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBRemoteAlertHandleServer$activate)(_LOGOS_SELF_TYPE_NORMAL SBRemoteAlertHandleServer* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBRemoteAlertHandleServer$activate(_LOGOS_SELF_TYPE_NORMAL SBRemoteAlertHandleServer* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBLockStateAggregator(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBLockStateAggregator"); } return _klass; }
#line 53 "Tweak.x"
BOOL isItLocked() {
	BOOL locked;
  int check =  [[_logos_static_class_lookup$SBLockStateAggregator() sharedInstance] lockState];
  if (check == 3 || check == 1) {
    locked = TRUE;
  } else {
    locked = FALSE;
  }
	return locked;
}


static NSString * _logos_method$_ungrouped$TUCall$displayName(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  realName = _logos_orig$_ungrouped$TUCall$displayName(self, _cmd);
  NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.apple.springboard.plist"];
  if ([defaults[@"CallHider-Status"] boolValue]) {
    for (NSString *contact in contactnamearray) {
      if ([realName containsString:contact]) {
        if (mask) {
          realName = fakename;
        }
        if (ringer) {
          [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CallHider-Ringer" object:nil userInfo:nil];
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
  [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CallHider-Ringer" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
    [self _updateRingerState:0 withVisuals:YES updatePreferenceRegister:YES];
  }];
  [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CallHider-Show" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      newDate = [NSDate date];
      if ([newDate timeIntervalSinceDate:oldDate] > 3 || oldDate == nil) {
        [self _simulateLockButtonPress];
        oldDate = [NSDate date];
      }
    });
  }];
  _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
}



static void _logos_method$_ungrouped$SBRemoteAlertHandleServer$activate(_LOGOS_SELF_TYPE_NORMAL SBRemoteAlertHandleServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  if (!hidecall) {
    _logos_orig$_ungrouped$SBRemoteAlertHandleServer$activate(self, _cmd);
  }
}




static __attribute__((constructor)) void _logosLocalCtor_343017e8(int __unused argc, char __unused **argv, char __unused **envp) {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.callhiderprefs.plist"];
  BOOL enable = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : YES;
  mask = prefs[@"mask"] ? [prefs[@"mask"] boolValue] : YES;
  ringer = prefs[@"ringer"] ? [prefs[@"ringer"] boolValue] : NO;
  hidecall = prefs[@"hidecall"] ? [prefs[@"hidecall"] boolValue] : NO;
  NSString *contactname = prefs[@"contactname"] && !([prefs[@"contactname"] isEqualToString:@""]) ? [prefs[@"contactname"] stringValue] : @"contact name;contact name";
  contactnamearray = [contactname componentsSeparatedByString:@";"];
  fakename = prefs[@"fakename"] && !([prefs[@"fakename"] isEqualToString:@""]) ? [prefs[@"fakename"] stringValue] : @"Fake Name";
  if (enable) {
    {Class _logos_class$_ungrouped$TUCall = objc_getClass("TUCall"); { MSHookMessageEx(_logos_class$_ungrouped$TUCall, @selector(displayName), (IMP)&_logos_method$_ungrouped$TUCall$displayName, (IMP*)&_logos_orig$_ungrouped$TUCall$displayName);}Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);}Class _logos_class$_ungrouped$SBRemoteAlertHandleServer = objc_getClass("SBRemoteAlertHandleServer"); { MSHookMessageEx(_logos_class$_ungrouped$SBRemoteAlertHandleServer, @selector(activate), (IMP)&_logos_method$_ungrouped$SBRemoteAlertHandleServer$activate, (IMP*)&_logos_orig$_ungrouped$SBRemoteAlertHandleServer$activate);}}
  }
}
