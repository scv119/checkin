//
//  CIFeedViewController.h
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface CIFeedViewController : UITableViewController<EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *refreshTableView;
    BOOL _reloading;
}

@property  (nonatomic, strong) NSMutableArray *feed;

@property  (nonatomic, strong) IBOutlet UITableView *tableView;

- (void) reloadFeed;

@end
