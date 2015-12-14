//
//  RegistrationIp.m
//  wifiSentinel
//
//  Created by michael russell on 2015-12-13.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "RegistrationIp.h"
#include <arpa/inet.h>
#import "RegistrationConfigureAP.h"

@implementation RegistrationIp


@synthesize ipAddressTextField=_ipAddressTextField;
@synthesize segment=_segment;
@synthesize loader=_loader;
@synthesize nextButton=_nextButton;
@synthesize serverIpAddress=_serverIpAddress;
@synthesize serverPort=_serverPort;
@synthesize serverSecret=_serverSecret;

-(void)getPublicIP:(void(^)(NSString *))block {
    NSURL *url = [NSURL URLWithString:@"http://checkip.dyndns.org"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            // consider handling error
        } else {
            NSString *html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
            NSString *ipAddr = [[html componentsSeparatedByCharactersInSet:numbers.invertedSet]componentsJoinedByString:@""];
            if (block) {
                block(ipAddr);
            }
        }
    }]resume];
}

-(void) updatePublicIP
{
    [self getPublicIP:^(NSString *ipAddr) {
        TGLog(@"public IP %@", ipAddr);
        dispatch_async(dispatch_get_main_queue(), ^{
            _ipAddressTextField.text=ipAddr;
            _nextButton.enabled=YES; _nextButton.alpha=1.0;
        });
        
    }];
    
}

- (BOOL)isValidIPAddress:(NSString*) ipaddr
{
    const char *utf8 = [ipaddr UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    
    return success == 1;
}

-(IBAction) segmentChanged:(id)sender
{
    if (_segment.selectedSegmentIndex==1)
    {
        _nextButton.enabled=NO; _nextButton.alpha=0.4;
        _ipAddressTextField.text=nil;
    } else {
        [self updatePublicIP];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TGMark;
    if ([self isValidIPAddress:textField.text])
    {
        _nextButton.enabled=YES; _nextButton.alpha=1.0;
    }

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    TGMark;
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // figure out public ip and display into field
    _segment.selectedSegmentIndex=0;
    _nextButton.enabled=NO; _nextButton.alpha=0.4;
    
    _serverIpAddress=nil;
    _serverPort=nil;
    
    [self updatePublicIP];
    
}

-(void) parseRegistration:(NSData*) data
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        TGLog(@"%@", localError);
        return;
    }
    TGLog(@"%@", parsedObject);
    
    NSString* status=[parsedObject valueForKey:@"status"];
    if ([status isEqualToString:@"error"])
    {
        TGLog(@"ERR %@", parsedObject);
        return;
    }
    
    NSString* action=[parsedObject valueForKey:@"action"];
    TGLog(@"%@", action);

    NSString* server_ip=[parsedObject valueForKey:@"server_ip"];
    NSString* server_port=[parsedObject valueForKey:@"server_port"];
    NSString* server_secret=[parsedObject valueForKey:@"server_secret"];
    
    BOOL created=NO;
    if ([action isEqualToString:REGISTRATION_ACTION_OUT_VALIDATED])
    {
        TGLog(@"ERR - already validated - shouldn't occur here.");
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];        
        return;
    } else if ([action isEqualToString:REGISTRATION_ACTION_OUT_UNKNOWN_DEVICE]){
        TGLog(@"ERR - create action shouldn't return unknown");
        return;
    } else if ([action isEqualToString:REGISTRATION_ACTION_OUT_CREATED_EXISTING]) {
        created=YES;
    } else if ([action isEqualToString:REGISTRATION_ACTION_OUT_CREATED_NEW]) {
        created=YES;
    } else {
        TGLog(@"ERR: unknown action out %@", action);
    }
    
    if (created)
    {
        if (server_ip==nil || server_port==nil)
        {
            TGLog(@"ERR");
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _serverIpAddress=[NSString stringWithString:server_ip];
            _serverPort=[NSString stringWithString:server_port];
            _serverSecret=[NSString stringWithString:server_secret];
            
            [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
            [_loader stopAnimating];
        });
    
    }
}

-(void) sendRegistration
{
    NSString *urlAsString = [NSString stringWithFormat:REGISTRATION_CREATE_URL, BASE_URL, REGISTRATION_ACTION_IN_CREATE,
        DEVICE_TOKEN,
        _ipAddressTextField.text];
    NSLog(@"%@", urlAsString);
    
    [_loader startAnimating];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlAsString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if (error) {
                    TGLog(@"FAILED");
                } else {
                    [self parseRegistration:data];
                }
            }] resume];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // only go onto next if we've sucessfully registered.
    if (!_serverIpAddress || !_serverPort) {
        
        // send a registration
        [self sendRegistration];
        
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RegistrationConfigureAP* regconfap_vc=(RegistrationConfigureAP*)[segue destinationViewController];
    regconfap_vc.serverIpAddress=_serverIpAddress;
    regconfap_vc.serverPort=_serverPort;
    regconfap_vc.secret=_serverSecret;
}


@end
