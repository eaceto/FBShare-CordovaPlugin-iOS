# FBShare (a Cordova Plugin for sharing links to Facebook in iOS)

## Installation

### Add to iOS project

    https://github.com/eaceto/FBShare-CordovaPlugin-iOS.git

### Include Facebook library

Drag and Drop the following files from "lib" to your XCode project

    FBSDKCoreKit.framework
    FBSDKLoginKit.framework
    FBSDKShareKit.framework

### AppDelegate

Add the following lines to the end of application:didFinishLaunchingWithOptions:

    return [FBSharing initWithApplication:application launchOptions:launchOptions];
    
Add the following lines to the end of application:openURL:sourceApplication:annotation:

    return [FBSharing application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
So and example AppDelegate will have:

    - (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
    {
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
        return [FBSharing initWithApplication:application launchOptions:launchOptions];
    }
    - (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
    {
        if (!url) {
            return NO;
        }
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
        return [FBSharing application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
### Call the share method
    
    var success = function(message) {
    }
    var failure = function() {
    }
    cordova.exec(success, failure, "FBSharing", "share", [<Link URL>,"<Link description>","<Your app name>"]);
    
    
    
