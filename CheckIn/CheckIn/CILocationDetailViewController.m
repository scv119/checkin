//
//  CILocationDetailViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-27.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CILocationDetailViewController.h"

@interface CILocationDetailViewController ()

@end

@implementation CILocationDetailViewController{
    MKPointAnnotation *annotation;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    [self.mapView addAnnotation:annotation];
    MKCoordinateSpan   span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    MKCoordinateRegion region;
    region.center = annotation.coordinate;
    region.span = span;
    
    NSLog(@"here");
    NSLog(@"%f, %f - %f, %f",	region.center.latitude,
          region.center.longitude,
          region.span.latitudeDelta,
          region.span.longitudeDelta);
    [self.mapView setRegion:region animated:NO];
    [self.view addSubview: self.mapView];
    NSLog(@"here1");
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setLocation:(CLLocation *) location withName:(NSString *)name withVicinity:(NSString *) vicinity
{
    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = location.coordinate.latitude;
    coordinate.longitude = location.coordinate.longitude;
    
    [annotation setCoordinate:coordinate];
    [annotation setTitle: name]; //You can set the subtitle too
    

}




@end
