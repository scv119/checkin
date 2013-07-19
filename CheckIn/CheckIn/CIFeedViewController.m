//
//  CIFeedViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIFeedViewController.h"
#import "CIFeedItem.h"
#import "CIViewController.h"
#import "AFJSONRequestOperation.h"


@implementation CIFeedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(checkinButtonPressed:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CIFeedShouldUpdate" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self reloadFeed];
    }];
}

-(void)checkinButtonPressed:(id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CIViewController *ci = [storyboard instantiateViewControllerWithIdentifier:@"CIViewController"];
    [self.navigationController pushViewController:ci animated:YES];
}

-(void) reloadFeed
{
    NSURL *url = [NSURL URLWithString:@"http://shenchen.mac:8888"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success!");
        NSArray *array = (NSArray *)JSON;
        for (id item in array) {
            NSArray *feed = (NSArray *)item;
            
            CIFeedItem *displayItem = [[CIFeedItem alloc] init];
            displayItem.feeling = feed[0];
            displayItem.created = [NSString stringWithFormat:@"%d", (int)feed[1]];
            [self.feed addObject:displayItem];
            NSLog(@"%@", feed[0]);
            NSLog(@"%@", feed[1]);
        }
        [self.tableView reloadData];
        
    } failure:nil];
    
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"invoked!");
    static NSString *CellIdentifier = @"CheckInCell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    CIFeedItem *item = [self.feed objectAtIndex:indexPath.row];
    cell.textLabel.text = item.feeling;
    cell.detailTextLabel.text = item.created;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSLog(@"Cell: %@ %@", cell.textLabel.text, cell.detailTextLabel.text);
    // Configure the cell...
    return cell;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self reloadFeed];
//}

@end
