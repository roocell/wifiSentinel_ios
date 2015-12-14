//
//  RegistrationConfigureAP.h
//  wifiSentinel
//
//  Created by michael russell on 2015-12-13.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationConfigureAP : UIViewController

@property (retain, nonatomic) IBOutlet UITextField* ipTextField;
@property (retain, nonatomic) IBOutlet UITextField* portTextField;
@property (retain, nonatomic) IBOutlet UITextField* secretTextField;

@property (retain, nonatomic) NSString* serverIpAddress;
@property (retain, nonatomic) NSString* serverPort;
@property (retain, nonatomic) NSString* secret;
@end
