#import "AppDelegate+applewatch.h"
#import "AppleWatch.h"
#import <objc/runtime.h>
#import "MainViewController.h"
#import <ImageIO/ImageIO.h>

static char watchKitRequestKey;

@implementation AppDelegate (applewatch)

// static UIBackgroundTaskIdentifier backgroundTaskId;

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply {

  // TODO not used yet, consider removing
  self.watchKitRequest = userInfo;

  NSString* jsFunction = [userInfo objectForKey:@"action"];

  // TODO if params is NSData, we should transform it into an image
  NSString* params;
  
  if ([jsFunction isEqualToString:@"onVoted"]) {
    if ([[userInfo objectForKey:@"params"] isKindOfClass:[NSData class]]) {
      // animated gif
      params = [NSString stringWithFormat:@"{'type':'base64img', 'data':'data:image/gif;base64,%@'}", [[userInfo objectForKey:@"params"] base64EncodedStringWithOptions:0]];
    } else {
      // text label, emoji, dictated text
      params = [NSString stringWithFormat:@"{'type':'text', 'data':'%@'}", [userInfo objectForKey:@"params"]];
    }
  } else {
    params = [NSString stringWithFormat:@"'%@'", [userInfo objectForKey:@"params"]];
  }

  // TODO stringwithformat
  NSString* result = [NSString stringWithFormat:@"%@(%@)", jsFunction, params == nil ? @"" : params];
  [self callJavascriptFunctionWhenAvailable:result];

  // no need to wait as data is passed back async
  reply(@{});
}

// check every x seconds for the phone  app to be ready, or stop from glance.didDeactivate
// TODO stop after x tries
- (void) callJavascriptFunctionWhenAvailable:(NSString*)function {
  AppleWatch *appleWatch = [self.viewController getCommandInstance:@"AppleWatch"];
  if (appleWatch.initDone) {
    [appleWatch.webView stringByEvaluatingJavaScriptFromString:function];
//    [appleWatch test2];
  } else {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 25 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
      [self callJavascriptFunctionWhenAvailable:function];
    });
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (NSMutableArray *)watchKitRequest {
  return objc_getAssociatedObject(self, &watchKitRequestKey);
}

- (void)setWatchKitRequest:(NSDictionary *)aDictionary {
  objc_setAssociatedObject(self, &watchKitRequestKey, aDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dealloc {
  self.watchKitRequest	= nil;
}


@end