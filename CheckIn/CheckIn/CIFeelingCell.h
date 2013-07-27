//
//  CIFeelingCell.h
//  CheckIn
//
//  Created by shen chen on 13-7-25.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIFeedItem.h"

@interface CIFeelingCell : UITableViewCell
{
    
@private
    CIFeedItem *_item;
}

@property CIFeedItem* item;

+ (CGFloat)heightForCellWithItem:(CIFeedItem *)item;

//+(void) setFeeling:(NSString *)feeling atCell:(CIFeelingCell*) cell;

@end
