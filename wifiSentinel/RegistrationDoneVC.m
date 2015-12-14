//
//  RegistrationDoneVC.m
//  wifiSentinel
//
//  Created by michael russell on 2015-12-13.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "RegistrationDoneVC.h"


@implementation RegistrationDoneVC
@synthesize doneButton=_doneButton;

-(IBAction)doneButtonPressed:(id)sender
{
    TGMark;
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
