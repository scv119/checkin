//
//  CIFeelingViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-24.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIFeelingViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface CIFeelingViewController ()

@end

@implementation CIFeelingViewController {
    UIColor *placeHolderColor;
    UIColor *textColor;
}

- (void)viewDidLoad
{
    self.navigationItem.titleView = [self getTitleView:[self.poi objectForKey:@"name"]];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem = button;
    self.feelingView.delegate = self;
    self.feelingView.textColor = [UIColor lightGrayColor];
    self.feelingView.font = [UIFont fontWithName:@"arial" size:15];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"keyboard showed!");
    CGRect rect = self.feelingView.frame;
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.size.height = screenRect.size.height - 120 - keyboardFrameBeginRect.size.height;
    self.feelingView.frame = rect;
}

-(void) keyboardWillHidden:(NSNotification *)notification
{
    
    NSLog(@"keyboard hidden!");
    CGRect rect = self.feelingView.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.size.height = screenRect.size.height - 120;
    self.feelingView.frame = rect;
}

- (UIView *) getTitleView:(NSString *)location
{
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 200, 50);
    UILabel *locationLabel = [[UILabel alloc] init];
    
    
    [titleView addSubview: locationLabel];
    locationLabel.frame = CGRectMake(0, 0, 200, 50);
    locationLabel.text = location;
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    return titleView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) submit: (id)sender
{
    [self sendFeeling];
}

- (void) sendFeeling
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://124.205.11.211:8888"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://124.205.11.211:8888"
                                                      parameters:@{@"data":self.feelingView.text,
                                                                    @"lng":[self.poi objectForKey:@"lng"],
                                                                    @"lat":[self.poi objectForKey:@"lat"],
                                                                    @"name":[self.poi objectForKey:@"name"]
                                                                    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self.navigationController popToRootViewControllerAnimated:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CIFeedShouldUpdate" object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.feelingView.textColor = [UIColor blackColor];
    self.feelingView.text = @"";
}

@end
