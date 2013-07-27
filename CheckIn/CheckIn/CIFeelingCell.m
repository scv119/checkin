//
//  CIFeelingCell.m
//  CheckIn
//
//  Created by shen chen on 13-7-25.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIFeelingCell.h"

@implementation CIFeelingCell

@synthesize item = _item;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, 320, 20);
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.imageView.image = [UIImage imageNamed:@"checkin.png"];
    
    return self;
}

- (void) setItem: (CIFeedItem *) item
{
    _item = item;
    self.textLabel.text = _item.name;
    self.detailTextLabel.text = _item.feeling;
    [self setNeedsLayout];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithItem:(CIFeedItem *)item {
    CGSize sizeToFit = [item.feeling sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(320.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:15];
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 20.0f, 20.0f);
    UILabel *atLabel = [[UILabel alloc] init];
    atLabel.frame = CGRectMake(40, 10, 18, 20);
    atLabel.text = @"在";
    atLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview: atLabel];
    self.textLabel.frame = CGRectMake(58.0f, 9.0f, 270.0f, 20.0f);
    
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, -20.0f, 25.0f);
    detailTextLabelFrame.size.height = [[self class] heightForCellWithItem:_item] - 45.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


@end
