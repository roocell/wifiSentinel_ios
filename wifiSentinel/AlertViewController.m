//
//  AlertViewController.m
//  wifiSentinel
//
//  Created by michael russell on 2015-12-03.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "AlertViewController.h"
#import "AppDelegate.h"

@interface AlertViewController ()

@end

@implementation AlertViewController
@synthesize username=_username;
@synthesize apns_data=_apns_data;

-(void) alertView:(NSString*) title withMsg:(NSString*) msg
{
    AppDelegate* appdel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:title
                                                                               message: msg
                                                                        preferredStyle:UIAlertControllerStyleAlert                   ];
    
    //Step 2: Create a UIAlertAction that can be added to the alert
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here, eg dismiss the alertwindow
                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    //Step 3: Add the UIAlertAction ok that we just created to our AlertController
    [myAlertController addAction: ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Step 4: Present the alert to the user
        [appdel.fvc presentViewController:myAlertController animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    TGLog(@"%@", _apns_data);
    // extract username from the apns_data
    NSDictionary* dataDict=[_apns_data valueForKey:@"data"];
    _username=[dataDict valueForKey:@"username"];
    
    NSDictionary* apsDict=[_apns_data valueForKey:@"aps"];
    
    _textView.text=[NSString stringWithFormat:@"%@",[apsDict valueForKey:@"alert"] ];
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#define ALLOWED_URL @"http://roocell.homeip.net/docker/new_user.php?username=%@&device_token=%@"

-(IBAction) allowButtonPressed:(id) sender
{
   TGMark;
   AppDelegate* appdel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *urlAsString = [NSString stringWithFormat:ALLOWED_URL, _username, appdel.apns_token];
    NSLog(@"%@", urlAsString);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlAsString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if (error) {
                    TGLog(@"FAILED");
                } else {
                    NSError *localError = nil;
                    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                    if (localError != nil) {
                        TGLog(@"%@", localError);
                        return;
                    }
                    TGLog(@"%@", parsedObject);
                    
                    NSRange search=[[parsedObject valueForKey:@"status"] rangeOfString:@"success"];
                    if (search.location != NSNotFound)
                    {
                        [self alertView:@"Access Granted" withMsg:@"The user should be able to connect now."];
                    }
                }
                
            }] resume];

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction) denyButtonPressed:(id) sender
{
    TGMark;
    // do we even need to do anything here ?
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self alertView:@"Access Denied" withMsg:@"You are the master of your domain!"];

}

@end
