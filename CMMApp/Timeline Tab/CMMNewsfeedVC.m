//
//  CMMNewsfeedVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMNewsfeedVC.h"
#import "CMMPost.h"
#import "NewsfeedCell.h"
#import "Masonry.h"
#import "PostDetailVC.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "NewsfeedSideMenuVC.h"

@interface CMMNewsfeedVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *filteredPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int queryNumber;
@end

@implementation CMMNewsfeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    self.view.backgroundColor = [UIColor purpleColor];
    self.title = @"Newsfeed";
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(didPressFilter:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    // create and populate table view
    int topBuffer = 0;
    CGRect tableViewFrame = CGRectMake(0, topBuffer, self.view.frame.size.width, self.view.frame.size.height - topBuffer);
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 55;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.queryNumber = 20;
    [self fetchPosts];
    
    // add search bar to table view
    CGRect searchFrame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    self.searchBar.delegate = self;
    self.table.tableHeaderView = self.searchBar;
    [self.view addSubview:self.table];
    
    // add refresh control to table view
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.table insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts {
    [[CMMParseQueryManager shared] fetchPosts:self.queryNumber WithCompletion:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            self.filteredPosts = posts;
            [self.table reloadData];
            [self.refreshControl endRefreshing];
            if (self.filteredPosts.count == self.queryNumber) {
                self.isMoreDataLoading = NO;
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didPressFilter:(id)sender {
    NSLog(@"filtering");
    [self.sideMenuController showRightViewAnimated];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            NSString *title = evaluatedObject[@"topic"];
            return [title containsString:searchText];
        }];
        self.filteredPosts = [self.posts filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredPosts = self.posts;
    }
    [self.table reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsfeedCell *cell = [[NewsfeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    CMMPost *post = self.filteredPosts[indexPath.row];
    [cell configureCell:post];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPosts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostDetailVC *detailVC = [[PostDetailVC alloc] init];
    CMMPost *post = self.filteredPosts[indexPath.row];
    [detailVC configureDetails:post];
    [[self navigationController] pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.table.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.table.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.table.isDragging) {
            self.isMoreDataLoading = true;
            self.queryNumber += 10;
            [self fetchPosts];
        }
    }
}

@end
