//
//  ListTableViewController.h
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import "ListTableViewController.h"
#import "FactOperation.h"
#import "AppDelegate.h"

#import "FactList.h"
#import "Fact.h"

#import "FactTableViewCell.h"

@interface ListTableViewController ()

@property (nonatomic, strong) NSArray *factArray;
@property (nonatomic, retain) NSMutableDictionary *factImageDictionary;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _factArray = [NSArray array];
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(loadFactList) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView  addSubview:self.tableRefreshControl];
    
    [self loadFactList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Fetching facts from web service

- (void) loadFactList {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [FactOperation getFactListOperationCompletion:^(id factListData) {
        NSLog(@"%@", factListData);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        FactList * factList = [[FactList alloc] initWithJSONData:factListData];
        self.title = factList.title;
        self.factArray = factList.facts;
        [self.tableView reloadData];
        if ([self.tableRefreshControl isRefreshing]) {
            [self.tableRefreshControl endRefreshing];
        }
        
    } errorHandler:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!!!", nil) message:error.description delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        if ([self.tableRefreshControl isRefreshing]) {
            [self.tableRefreshControl endRefreshing];
        }
    }];
    
}


#pragma TableView delegates/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_factArray count] > 0 ? [_factArray count] : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_factArray count] == 0) {
        return 50;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_factArray count] == 0) {
        UITableViewCell *loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataIdentifier"];
        loadingCell.textLabel.text = @"Loading...";
        loadingCell.textLabel.textAlignment = NSTextAlignmentCenter;
        return loadingCell;
    }
    
    Fact *fact = _factArray[indexPath.row];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld", (long)[indexPath row]];
    
    FactTableViewCell * factCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (factCell == nil)
    {
        factCell = [[FactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier fact:fact];
        [factCell configureCell:fact];
    }
    return factCell;
}

@end
