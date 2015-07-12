#import "Foundation/Foundation.h"
#import "Cordova/CDV.h"

@interface AppleWatch : CDVPlugin

@property BOOL initDone;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) registerNotifications:(CDVInvokedUrlCommand*)command;
- (void) sendMessage:(CDVInvokedUrlCommand*)command;
- (void) sendNotification:(CDVInvokedUrlCommand*)command;
- (void) sendUserDefaults:(CDVInvokedUrlCommand*)command;
- (void) addListener:(CDVInvokedUrlCommand*)command;
- (void) removeListener:(CDVInvokedUrlCommand*)command;
- (void) purgeQueue:(CDVInvokedUrlCommand*)command;
- (void) purgeAllQueues:(CDVInvokedUrlCommand*)command;

@end
