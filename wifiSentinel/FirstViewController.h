//
//  FirstViewController.h
//  wifiSentinel
//
//  Created by michael russell on 2015-11-30.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* userlist;  // NSStrings
}
@property (retain, nonatomic) IBOutlet UITableView* tableView;
@property (retain, nonatomic) NSMutableArray* userlist;
@property (retain, nonatomic) UIRefreshControl* refreshControl;
@end

