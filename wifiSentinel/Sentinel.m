//
//  Sentinel.m
//  wifiSentinel
//
//  Created by michael russell on 2015-12-13.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "Sentinel.h"

@implementation Sentinel
@synthesize _id=__id;
@synthesize device_token=_device_token;
@synthesize apip=_apip;

-(id) init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
