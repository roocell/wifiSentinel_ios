//
//  FirstViewController.m
//  wifiSentinel
//
//  Created by michael russell on 2015-11-30.
//  Copyright © 2015 ThumbGenius Software. All rights reserved.
//

#import "FirstViewController.h"
#import "user.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@end

#define USERS_URL @"%@/users.php"
#define DELETE_USER_URL @"%@/delete_user.php?username=%@&device_token=%@"


@implementation FirstViewController
@synthesize  userlist=_userlist;
@synthesize tableView=_tableView;
@synthesize refreshControl=_refreshControl;


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


-(void) parseUsers:(NSData*) data
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];

    if (localError != nil) {
        TGLog(@"%@", localError);
        return;
    }
    TGLog(@"%@", parsedObject);

    NSArray *results = [parsedObject valueForKey:@"success"];
    TGLog(@"%lu users", (unsigned long)results.count);
    
    for (NSDictionary *userDic in results) {
        user *u = [[user alloc] init];
        
        for (NSString *key in userDic) {
            //TGLog(@"%@=%@", key, [userDic valueForKey:key]);
            if ([u respondsToSelector:NSSelectorFromString(key)]) {
                [u setValue:[userDic valueForKey:key] forKey:key];
            }
        }
        [_userlist addObject:u];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [_tableView reloadData];
    });
    
}

-(void) getUsers
{
    [_userlist removeAllObjects];
    NSString *urlAsString = [NSString stringWithFormat:USERS_URL, BASE_URL];
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
                    [self parseUsers:data];
                }
                [_refreshControl endRefreshing];
            }] resume];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    AppDelegate* appdel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdel.fvc=self;
    
    NSLog(@"size : %f - %f ", _tableView.frame.size.width, _tableView.bounds.size.width);
    
    _userlist=[NSMutableArray arrayWithCapacity:0];

    [self getUsers];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getUsers)
                  forControlEvents:UIControlEventValueChanged];
    
[   _tableView insertSubview:_refreshControl atIndex:0];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = _tableView;
    tableViewController.refreshControl = _refreshControl;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([_userlist count])
    {
        _tableView.backgroundView = nil;
        return 1;
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        _tableView.backgroundView = messageLabel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}

/*

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"USER_TABLE_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *userLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:101];
    
    user* u=[_userlist objectAtIndex:[indexPath row]];
 

    userLabel.text=[NSString stringWithFormat:@"%@", u.username];
    timeLabel.text=[NSString stringWithFormat:@"<%@>", u.expiry];
 
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    TGLog(@"");
    // doesn't get called when using add button
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        AppDelegate* appdel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        user* u=[_userlist objectAtIndex:[indexPath row]];
        TGLog(@"delete user %@", u.username);

        NSString *urlAsString = [NSString stringWithFormat:DELETE_USER_URL, BASE_URL, u.username, appdel.apns_token];
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
                        
                        NSRange search=[[parsedObject valueForKey:@"status"] rangeOfString:@"deleted"];
                        if (search.location != NSNotFound)
                        {
                            [self alertView:@"User Deleted" withMsg:[NSString stringWithFormat:@"%@ can't mess with your network any longer.", u.username]];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self getUsers];
                        });

                    }
                }] resume];

    }
}



#pragma PULL DOWN TO REFRESH
- (void)reloadTableViewDataSource
{
    
}


@end
