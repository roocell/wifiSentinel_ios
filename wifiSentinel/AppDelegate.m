//
//  AppDelegate.m
//  wifiSentinel
//
//  Created by michael russell on 2015-11-30.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "AppDelegate.h"
#import "PushNotification.h"
#import "AlertViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize apns_token=_apns_token;
@synthesize fvc=_fvc;

-(void) showInAppAlert:(NSDictionary*) userInfo
{
    TGLog(@"%@", userInfo);

    // show in-app alert
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AlertViewController* avc = (AlertViewController*) [storyboard        instantiateViewControllerWithIdentifier:@"ALERT_VIEW_CONTROLLER"];
    
    avc.apns_data=[NSDictionary dictionaryWithDictionary:userInfo];
    
    [_fvc presentViewController:avc animated:YES completion:^{}];
    

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Let the device know we want to receive push notifications
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    // Override point for customization after application launch.
    // Checking if application was launched by tapping icon, or push notification
    if (!launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        TGLog(@"processing icon tap or notification tap");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (userInfo) {
            // Launched by tapping icon
            // ... your handling here
            [self showInAppAlert:userInfo];
        }
    } else {
        TGLog(@"processing swiped notification");
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self showInAppAlert:userInfo];
        }
    }

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"My token is: %@", deviceToken);
    NSLog(@"My hextoken is: %@", hexToken);
    
    _apns_token=[NSString stringWithString:hexToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

-(void) writeUserInfoToFile:(NSDictionary*) userInfo
{
    // When we get a push, just writing it to file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
    [userInfo writeToFile:filePath atomically:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    
    TGLog(@"APNS triggered: %@", userInfo);

    if(application.applicationState == UIApplicationStateInactive) {
        
        NSLog(@"Inactive");
        
        [self writeUserInfoToFile:userInfo];
        //Show the view with the content of the push
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"Background");
        [self writeUserInfoToFile:userInfo];
       
        //Refresh the local model 
        [self showInAppAlert:userInfo];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else {
        
        NSLog(@"Active");
        
        [self showInAppAlert:userInfo];
                
        completionHandler(UIBackgroundFetchResultNewData);
  
    }

    

    
}

@end
