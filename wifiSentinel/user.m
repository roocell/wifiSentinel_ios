//
//  user.m
//  wifiSentinel
//
//  Created by michael russell on 2015-12-02.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "user.h"

@implementation user
@synthesize username=_username;
@synthesize expiry=_expiry;

-(id) init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end