//
//  RegistrationConfigureAP.m
//  wifiSentinel
//
//  Created by michael russell on 2015-12-13.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "RegistrationConfigureAP.h"

@implementation RegistrationConfigureAP
@synthesize ipTextField=_ipTextField;
@synthesize portTextField=_portTextField;
@synthesize serverIpAddress=_serverIpAddress;
@synthesize serverPort=_serverPort;
@synthesize secret=_secret;
@synthesize secretTextField=_secretTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ipTextField.text=_serverIpAddress;
    _portTextField.text=_serverPort;
    _secretTextField.text=_secret;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
