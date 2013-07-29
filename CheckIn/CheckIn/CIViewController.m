//
//  CIViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIViewController.h"
#import "CIFeelingViewController.h"
#import "AFJSONRequestOperation.h"
#import "CIEarth2Mars.h"


@interface CIViewController ()

@end

@implementation CIViewController {
    CLLocationManager *locationManager;
    
    UIView *tableHeadView;
    UISearchBar *searchBar;
    UIFont *lableFont;
    UIFont *detailFont;
    UIActivityIndicatorView *ac, *searchAc;
    UISearchDisplayController *searchDisplayController;
    CGRect windowRec;
    
}

- (void) loadView
{
    [super loadView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    ac = [[UIActivityIndicatorView alloc]
          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    windowRec = [[UIScreen mainScreen] bounds];
    tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, windowRec.size.width, 260)];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, windowRec.size.width, 44)];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44,windowRec.size.width, 200)];
    self.mapView.delegate = self;
    ac.frame = CGRectMake(0, 244, windowRec.size.width , 50);
    [tableHeadView addSubview:searchBar];
    [tableHeadView addSubview:self.mapView];
    [tableHeadView addSubview:ac];
    //[view addSubview:ac];
    self.tableView.tableHeaderView = tableHeadView;
    [ac startAnimating];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.mapView.showsUserLocation = TRUE;
    cellContent = [[NSMutableArray alloc] init];
    searchResult = [[NSMutableArray alloc] init];
    self.currentArray = cellContent;
    
    locationManager = [[CLLocationManager alloc] init];
    lableFont = [UIFont fontWithName:@"Helvetica-Bold" size: 14.0 ];
    detailFont = [UIFont fontWithName:@"Helvetica" size:12];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10.0f;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController: self];
    [searchDisplayController setDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    [searchDisplayController setSearchResultsDelegate:self];
    [searchBar setDelegate:self];
    
    searchAc = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    searchAc.frame = CGRectMake(0, 0, windowRec.size.width, windowRec.size.height / 3);
    
    [locationManager startUpdatingLocation];



}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSLog(@"location start to update");

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locationManager location];
    location = [CIEarth2Mars earth2mars:location];
    NSLog(@"location updated %@", [location description]);
    
    [self nearbyWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location.coordinate,1000 ,1000 );
    [self.mapView setRegion:region animated:NO];
    
}


//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    CLLocation *location = userLocation.location;
////    location = [CIEarth2Mars earth2mars:location];
//    NSLog(@"location updated %@", [location description]);
//    
//    [self nearbyWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location.coordinate,1000 ,1000 );
//    [self.mapView setRegion:region animated:TRUE];
//}


-(void) nearbyWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees) lng
{
    NSString *str = [[NSString alloc] initWithFormat:@"http://124.205.11.211:8888/nearby?lat=%f&lng=%f&offset=0&limit=12", lat, lng];\
    NSLog(@"nearby start! %@", str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"nearby Success!");
        [cellContent removeAllObjects];
        NSArray *array = (NSArray *)JSON;
        int size = 0;
        for (id item in array) {
            NSDictionary *poi = (NSDictionary *)item;
            [cellContent addObject:poi];
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
        [ac stopAnimating];
        [tableHeadView setFrame:CGRectMake(0, 0, tableHeadView.frame.size.width, 244)];
        self.tableView.tableHeaderView = tableHeadView;
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView reloadData];
//        self.tableView.tableHeaderView = nil;
        
    } failure:nil];
    
    NSLog(@"start!");
    [operation start];
    NSLog(@"end!");

}





-(void) nearbyWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees) lng query:(NSString *) query
{
    NSString *encodedValue = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(encodedValue);
    NSString *str = [[NSString alloc] initWithFormat:@"http://124.205.11.211:8888/nearby?lat=%f&lng=%f&offset=0&limit=12&query=%@", lat, lng, encodedValue];\
    NSLog(@"nearby start! %@", str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    int requestId = ++ self.currentRequestId;
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"nearby Success!");
        if (requestId != self.currentRequestId) {
            NSLog(@"new request override this one");
            return;
        }
        [searchResult removeAllObjects];
        NSArray *array = (NSArray *)JSON;
        for (id item in array) {
            NSDictionary *poi = (NSDictionary *)item;
            [searchResult addObject:poi];
        }
        
//        NSLog(@"table View start to reload");
        [searchAc stopAnimating];
        self.searchDisplayController.searchResultsTableView.tableHeaderView = nil;
        if ([searchResult count] > 0)
            [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//        [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, self.searchDisplayController.searchResultsTableView.frame.origin.y, windowRec.size.width, 50 * [searchResult count])];
        [self.searchDisplayController.searchResultsTableView reloadData];
        //        self.tableView.tableHeaderView = nil;
        
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
{	return [self.currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckInCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *item = [self.currentArray objectAtIndex:indexPath.row ];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font  = lableFont;
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.detailTextLabel.font = detailFont;
    cell.detailTextLabel.text = [item objectForKey:@"vicinity"];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    
    searchDisplayController.searchResultsTableView.tableHeaderView = searchAc;
    [searchAc startAnimating];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    NSLog(@"key words:%@", searchString);
    CLLocation *location = [locationManager location];
    NSLog(@"location updated %@", [location description]);
    [searchResult removeAllObjects];
    [self nearbyWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude query:searchString];
    return TRUE;
}


- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.currentArray = searchResult;
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.currentArray = cellContent;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    for (id subview in self.searchDisplayController.searchResultsTableView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            ((UILabel *)subview).text = @"";
        }
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CIFeelingViewController *ci = [storyboard instantiateViewControllerWithIdentifier:@"CIFeelingViewController"];
    ci.poi = [self.currentArray objectAtIndex: indexPath.row];
    [self.navigationController pushViewController:ci animated:YES];
    
}


@end
