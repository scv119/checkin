//
//  CIFeedItem.h
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CIFeedItem : NSObject

@property NSString *feeling;
@property NSString *created;
@property NSString *name;
@property CLLocation *location;

-(NSString *) getFormattedTime;

@end
