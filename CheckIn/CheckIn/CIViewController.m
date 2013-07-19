//
//  CIViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface CIViewController ()

@end

@implementation CIViewController {
    CLLocationManager *locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.showsUserLocation = TRUE;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10.0f;
    [locationManager startUpdatingLocation];
    NSLog(@"location start to update");

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locations lastObject];
    NSLog(@"location updated %@", [location description]);
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location.coordinate,1000 ,1000 );
    [self.mapView setRegion:region animated:TRUE];
    
    NSString *url = @"https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&rankby=distance&types=food&name=harbour&language=zh-CN&sensor=false&key=AIzaSyDLtz4_hWO-iGpy5RT8SxZi-YcZTZYTVXY";
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"invoked!");
    static NSString *CellIdentifier = @"CheckInCell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    return cell;
}

@end
