//
//  AlertViewController.h
//  wifiSentinel
//
//  Created by michael russell on 2015-12-03.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO: should probably just subclass UIAlertAction

@interface AlertViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView* textView;
@property (retain, nonatomic) IBOutlet UIButton*   allowButton;
@property (retain, nonatomic) IBOutlet UIButton*   denyButton;
@property (retain, nonatomic) NSString*   username;
@property (retain, nonatomic) NSDictionary*   apns_data;

-(IBAction) allowButtonPressed:(id) sender;
-(IBAction) denyButtonPressed:(id) sender;

-(void) alertView:(NSString*) title withMsg:(NSString*) msg;
@end
