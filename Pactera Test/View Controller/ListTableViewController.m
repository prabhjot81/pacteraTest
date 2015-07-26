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

dispatch_queue_t myBackgroundQueue;

@interface ListTableViewController ()

@property (nonatomic, strong) NSArray *factArray;
@property (nonatomic, retain) NSMutableDictionary *factImageDictionary;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSString *errorMsg;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _factArray = [NSArray array];
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(loadFactList) forControlEvents:UIControlEventValueChanged];
    
    self.errorMsg = NSLocalizedString(@"Loading...", nil) ; // Initial message
    
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
        
        if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        if ([self.tableRefreshControl isRefreshing]) {
            [self.tableRefreshControl endRefreshing];
        }
        
        FactList * factList = [[FactList alloc] initWithJSONData:factListData];
        self.title = factList.title;
        self.factArray = factList.facts;
        [self.tableView reloadData];
        
    } errorHandler:^(NSError *error) {
        
        if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }        if ([self.tableRefreshControl isRefreshing]) {
            [self.tableRefreshControl endRefreshing];
        }
        
        self.errorMsg = error.userInfo[@"NSLocalizedDescription"] ? error.userInfo[@"NSLocalizedDescription"] : NSLocalizedString(@"Exceptional error occured!!!", nil);
        self.factArray = nil;
        [self.tableView reloadData];
    }];
    
}


#pragma TableView delegates/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_factArray count] > 0 ? [_factArray count] : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_factArray count] == 0) { //  Default case for error handling
        return 50;
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld", (long)[indexPath row]];
    Fact *fact = _factArray[indexPath.row];
    
    FactTableViewCell * factCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (factCell == nil)
    {
        factCell = [[FactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier fact:fact];
        [factCell configureCell:fact];
    }
    int height = factCell.contentView.frame.size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_factArray count] == 0) { //  Default case for error handling
        UITableViewCell *loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataIdentifier"];
        loadingCell.textLabel.text = self.errorMsg;
        loadingCell.textLabel.font = [UIFont systemFontOfSize:14];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_factArray count] == 0) {
        return;
    }
    Fact *inFact = _factArray[indexPath.row];
    if (inFact.userImage == nil && inFact.image.length > 0) {
        FactTableViewCell *factCell = (FactTableViewCell *)cell;
        // set default user image while image is being downloaded
        factCell.factImage.image = [UIImage imageNamed:@"default-placeholder"];
        // download the image asynchronously
        myBackgroundQueue = dispatch_queue_create("com.telstra.photo", NULL);
        dispatch_async(myBackgroundQueue, ^(void) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:inFact.image]];
            if (imageData) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    factCell.factImage.image = [UIImage imageWithData:imageData];
                    inFact.userImage = [UIImage imageWithData:imageData];
                });
            } else { // If image is not available, then change it's width constraint to 0
                factCell.factImageWidthConstraint.constant = 0;
            }
        });
    }
}

@end
