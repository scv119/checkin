//
//  CIFeedItem.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIFeedItem.h"

@implementation CIFeedItem


-(NSString *) getFormattedTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[self.created doubleValue]];
    return [dateFormatter stringFromDate:date];
}



@end
