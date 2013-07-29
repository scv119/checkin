//
//  CIFeedViewController.m
//  CheckIn
//
//  Created by shen chen on 13-7-16.
//  Copyright (c) 2013年 me.scv119. All rights reserved.
//

#import "CIFeedViewController.h"
#import "CILocationDetailViewController.h"
#import "CIFeedItem.h"
#import "CIViewController.h"
#import "AFJSONRequestOperation.h"
#import "CIFeelingCell.h"


@implementation CIFeedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (refreshTableView == nil) {
        refreshTableView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,  0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width,  self.tableView.bounds.size.height)];
        refreshTableView.delegate = self;
        [self.tableView addSubview:refreshTableView];
        
        [refreshTableView refreshLastUpdatedDate];
    }
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    
    UIBarButtonItem *btn  = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStyleBordered target:self action:@selector(checkinButtonPressed:)];
    self.navigationItem.rightBarButtonItem = btn;
    
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
    NSURL *url = [NSURL URLWithString:@"http://124.205.11.211:8888"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success!");
        NSArray *array = (NSArray *)JSON;
        [self.feed removeAllObjects];
        for (id item in array) {
            NSDictionary *feed = (NSDictionary *)item;
            
            CIFeedItem *displayItem = [[CIFeedItem alloc] init];
            displayItem.feeling = [feed objectForKey:@"data"];
            displayItem.created =[feed objectForKey:@"created"];
            displayItem.name = [feed objectForKey:@"name"];
            displayItem.location = [[CLLocation alloc] initWithLatitude:[[feed objectForKey:@"lat"] floatValue] longitude:[[feed objectForKey:@"lng"] floatValue] ];
            NSLog(@"%@, %@, %@", [feed objectForKey:@"created"], displayItem.name, displayItem.created);

            [self.feed addObject:displayItem];
        }
        [self.tableView reloadData];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    }];
    
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
    
    CIFeelingCell *cell = nil;
    
    cell = (CIFeelingCell *)[tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
// ERROR happens
    
    if (cell == nil) {
        cell = [[CIFeelingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    CIFeedItem *item = [self.feed objectAtIndex:indexPath.row];
    cell.item = item;
    
    NSLog(@"Cell: %@ %@", cell.textLabel.text, cell.detailTextLabel.text);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    // Configure the cell...
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CIFeelingCell heightForCellWithItem:[self.feed objectAtIndex:indexPath.row]];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected!");
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CILocationDetailViewController *ci = [storyboard instantiateViewControllerWithIdentifier:@"CILocationDetailViewController"];
    CIFeedItem *item = [self.feed objectAtIndex:indexPath.row];
    [ci setLocation:item.location withName:item.name withVicinity:@""];
    [self.navigationController pushViewController:ci animated:YES];
    
}



#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    [self reloadFeed];
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    
}



#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
   
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


@end
