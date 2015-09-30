#import <Cordova/CDV.h>

@interface FBSharing : CDVPlugin

- (void)share:(CDVInvokedUrlCommand*)command;

+ (BOOL)initWithApplication:(UIApplication *)application
              launchOptions:(NSDictionary *)launchOptions;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@end