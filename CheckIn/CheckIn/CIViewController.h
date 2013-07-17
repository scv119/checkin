//
//  CIViewController.h
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CIViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *pickerArray;
}

-(IBAction)selectButton:(id)sender;

@property (nonatomic, strong) IBOutlet UIPickerView *pickView;
@end
