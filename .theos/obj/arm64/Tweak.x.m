#line 1 "Tweak.x"
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

@class SpringBoard; @class TUCall; 
static NSString * (*_logos_orig$_ungrouped$TUCall$displayName)(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$TUCall$displayName(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SpringBoard(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SpringBoard"); } return _klass; }
#line 13 "Tweak.x"
NSArray *contactnamearray;
NSString *fakename;
BOOL mask;
BOOL ringer;

static NSString * _logos_method$_ungrouped$TUCall$displayName(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  NSString *realName = _logos_orig$_ungrouped$TUCall$displayName(self, _cmd);
  for (NSString *contact in contactnamearray) {
    if ([realName containsString:contact]) {
      if (mask) {
        realName = fakename;
      }
      if (ringer) {
        SpringBoard *springboard = [_logos_static_class_lookup$SpringBoard() sharedApplication];
        [springboard _updateRingerState:0 withVisuals:YES updatePreferenceRegister:YES];
      }
      break;
    }
  }
  return realName;
}


static __attribute__((constructor)) void _logosLocalCtor_e1bc82cf(int __unused argc, char __unused **argv, char __unused **envp) {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.callhiderprefs.plist"];
  BOOL enable = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : YES;
  mask = prefs[@"mask"] ? [prefs[@"mask"] boolValue] : YES;
  ringer = prefs[@"ringer"] ? [prefs[@"ringer"] boolValue] : NO;
  NSString *contactname = prefs[@"contactname"] && !([prefs[@"contactname"] isEqualToString:@""]) ? [prefs[@"contactname"] stringValue] : @"contact name;contact name";
  contactnamearray = [contactname componentsSeparatedByString:@";"];
  fakename = prefs[@"fakename"] && !([prefs[@"fakename"] isEqualToString:@""]) ? [prefs[@"fakename"] stringValue] : @"Fake Name";
  if (enable) {
    {Class _logos_class$_ungrouped$TUCall = objc_getClass("TUCall"); { MSHookMessageEx(_logos_class$_ungrouped$TUCall, @selector(displayName), (IMP)&_logos_method$_ungrouped$TUCall$displayName, (IMP*)&_logos_orig$_ungrouped$TUCall$displayName);}}
  }
}
