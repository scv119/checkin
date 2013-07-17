//
//  CIViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface CIViewController ()

@end

@implementation CIViewController

- (void)viewDidLoad
{    
    pickerArray = [NSArray arrayWithObjects:@"心情很好",@"看到女神",@"我靠",@"球别说", nil]; 
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

-(IBAction)selectButton:(id)sender
{
    NSInteger idx = [self.pickView selectedRowInComponent:0];
    NSString *message = [pickerArray objectAtIndex:idx];
    NSLog(@"button clicked %@", message);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://shenchen.mac:8888/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://shenchen.mac:8888/"
                                                      parameters:@{@"data":message}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CIFeedShouldUpdate" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];

}

@end
