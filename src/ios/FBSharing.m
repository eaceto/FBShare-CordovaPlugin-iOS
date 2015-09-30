#import "FBSharing.h"
#import <Social/Social.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBSharing() <FBSDKSharingDelegate> {
    
}
@property (nonatomic, strong) NSString* alertViewTitle;
@property (nonatomic, strong) NSError* error;

@end

@implementation FBSharing

+ (BOOL)initWithApplication:(UIApplication *)application
              launchOptions:(NSDictionary *)launchOptions {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)share:(CDVInvokedUrlCommand*)command
{
    NSString* link = [[command arguments] objectAtIndex:0];
    NSString* text = [[command arguments] objectAtIndex:1];
    NSString* app = [[command arguments] objectAtIndex:2];
    
    BOOL done = [self shareLink:link content:text titleForAlert:app fromViewController:self.viewController];
    
    CDVPluginResult* pluginResult = nil;
    if (done) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(BOOL)shareLink:(NSString*)link content:(NSString*)text titleForAlert:(NSString*)title fromViewController:(UIViewController*) vc {
    NSLog(@"Will share %@ and %@",link, text);
    
    _alertViewTitle = title;
    _error = nil;
    
    BOOL fbAppInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    BOOL canShare = NO;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        canShare = YES;
        SLComposeViewController * sl = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [sl setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        if (text != nil)[sl setInitialText:text];
        @try {
            if (link != nil) [sl addURL:[NSURL URLWithString:link]];
        } @catch (NSException* e) {}
        [vc presentViewController:sl animated:YES completion:NULL];
    }
    else if (fbAppInstalled) {
        FBSDKShareLinkContent* content = [[FBSDKShareLinkContent alloc] init];
        if (text != nil) [content setContentDescription:text];
        @try {
            if (link != nil) [content setContentURL:[NSURL URLWithString:link]];
        } @catch (NSException* e) {}
        
        FBSDKShareDialog *dialog;
        dialog = [FBSDKShareDialog showFromViewController:vc withContent:content delegate:self];
        dialog.mode = FBSDKShareDialogModeShareSheet;
        canShare = [dialog show];
        NSLog(@"");
    }
    else {
        [[[UIAlertView alloc] initWithTitle:_alertViewTitle message:@"No se puede compartir en Facebook. Asegurate de tener una cuenta de Facebook configurada." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
    }
    return canShare;
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (_error) return;
    _error = error;
    [[[UIAlertView alloc] initWithTitle:_alertViewTitle message:@"No se puede compartir en Facebook. Asegurate de tener una cuenta de Facebook configurada." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
}

@end