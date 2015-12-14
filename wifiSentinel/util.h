/*
 *  util.h
 *
 *  Created by michael russell on 10-11-15.
 *  Copyright 2010 Thumb Genius Software. All rights reserved.
 *
 */
#import "AppDelegate.h"

#define BASE_URL @"http://roocell.homeip.net/docker"

#define TGLog(message, ...) NSLog(@"%s:%d %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:message, ##__VA_ARGS__])
#define TGMark    TGLog(@"");


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#define USERS_URL @"%@/users.php?device_token=%@"
#define DELETE_USER_URL @"%@/delete_user.php?username=%@&device_token=%@"

#define REGISTRATION_CHECK_URL  @"%@/registration.php?action=%@&device_token=%@"
#define REGISTRATION_CREATE_URL @"%@/registration.php?action=%@&device_token=%@&apip=%@"
#define REGISTRATION_ACTION_IN_CHECK    @"check"
#define REGISTRATION_ACTION_IN_CREATE   @"create"

#define REGISTRATION_ACTION_OUT_CREATED_EXISTING    @"created_existing"
#define REGISTRATION_ACTION_OUT_CREATED_NEW         @"created_new"
#define REGISTRATION_ACTION_OUT_VALIDATED           @"validated"
#define REGISTRATION_ACTION_OUT_UNKNOWN_DEVICE      @"unknown_device"


#define DEVICE_TOKEN [((AppDelegate*)[[UIApplication sharedApplication] delegate]) apns_token]
