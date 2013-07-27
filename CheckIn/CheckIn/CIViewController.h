//
//  CIViewController.h
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CIViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate> {
    NSMutableArray *cellContent;
    NSMutableArray *searchResult;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, weak) NSMutableArray *currentArray;

@property (atomic) int currentRequestId;

-(void) nearbyWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees) lng;

@end
