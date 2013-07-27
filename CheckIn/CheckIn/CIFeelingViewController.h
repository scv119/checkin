//
//  CIFeelingViewController.h
//  CheckIn
//
//  Created by shen chen on 13-7-24.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIFeelingViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *feelingView;

@property (nonatomic, strong) NSDictionary *poi;

@end
