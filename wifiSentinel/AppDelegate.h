//
//  AppDelegate.h
//  wifiSentinel
//
//  Created by michael russell on 2015-11-30.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *apns_token;
@property (retain, nonatomic) FirstViewController* fvc;

@end

