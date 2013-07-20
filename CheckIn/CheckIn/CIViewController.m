//
//  CIViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIViewController.h"
#import "AFJSONRequestOperation.h"


@interface CIViewController ()

@end

@implementation CIViewController {
    CLLocationManager *locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.mapView.showsUserLocation = TRUE;
    cellContent = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10.0f;
    [locationManager startUpdatingLocation];
    NSLog(@"location start to update");

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locationManager location];
    NSLog(@"location updated %@", [location description]);
    [self nearbyWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location.coordinate,1000 ,1000 );
    [self.mapView setRegion:region animated:TRUE];
    
}

-(void) nearbyWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees) lng
{
    NSString *str = [[NSString alloc] initWithFormat:@"http://124.205.11.211:8888/nearby?lat=%f&lng=%f&offset=0&limit=12", lat, lng];\
    NSLog(@"nearby start! %@", str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"nearby Success!");
        NSArray *array = (NSArray *)JSON;
        int size = 0;
        for (id item in array) {
            NSDictionary *poi = (NSDictionary *)item;
            [cellContent addObject:poi];
//            NSLog(@"%@", [poi objectForKey:@"lat"]);
//            NSLog(@"%@", [poi objectForKey:@"lng"]);
//            NSLog(@"%@", [poi objectForKey:@"name"]);
//            NSLog(@"%@", [poi objectForKey:@"vicinity"]);
            if (size ++ < 5) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = ((NSNumber *)[poi objectForKey:@"lat"]).doubleValue;
            coordinate.longitude = ((NSNumber *)[poi objectForKey:@"lng"]).doubleValue;
            
            [annotation setCoordinate:coordinate];
            [annotation setTitle: [poi objectForKey:@"name"]]; //You can set the subtitle too
            [self.mapView addAnnotation:annotation];
            }
        }
        
        NSLog(@"table View start to reload");
        [self.tableView reloadData];
        
    } failure:nil];
    
    NSLog(@"start!");
    [operation start];
    NSLog(@"end!");

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
     NSLog(@"table view loading!");
	return [cellContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"table view loading!");
    static NSString *CellIdentifier = @"CheckInCell";
//    
//    if (indexPath.row == 0)
//        return [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *item = [cellContent objectAtIndex:indexPath.row ];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.detailTextLabel.text = [item objectForKey:@"vicinity"];
    NSLog(@"Cell: %@ %@", cell.textLabel.text, cell.detailTextLabel.text);
    // Configure the cell...
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
