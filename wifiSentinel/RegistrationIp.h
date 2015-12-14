//
//  RegistrationIp.h
//  wifiSentinel
//
//  Created by michael russell on 2015-12-13.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationIp : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UISegmentedControl* segment;
@property (retain, nonatomic) IBOutlet UITextField* ipAddressTextField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* loader;
@property (retain, nonatomic) IBOutlet UIButton* nextButton;
@property (retain, nonatomic) NSString* serverIpAddress;
@property (retain, nonatomic) NSString* serverPort;
@property (retain, nonatomic) NSString* serverSecret;

-(IBAction) segmentChanged:(id)sender;

//-(IBAction)nextButtonPressed:(id)sender;

@end
