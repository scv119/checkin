//
//  CIFeedViewController.h
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIFeedViewController : UITableViewController

@property  (nonatomic, strong) NSMutableArray *feed;

@property  (nonatomic, strong) IBOutlet UITableView *tableView;

- (void) reloadFeed;

@end
