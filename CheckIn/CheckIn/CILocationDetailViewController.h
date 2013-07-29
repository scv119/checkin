//
//  CILocationDetailViewController.h
//  CheckIn
//
//  Created by shen chen on 13-7-27.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CILocationDetailViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

-(void) setLocation:(CLLocation *) location withName:(NSString *)name withVicinity:(NSString *) vicinity;

@end
