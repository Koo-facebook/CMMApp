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
#import "CMMStyles.h"
#import "CMTabbarView.h"

static NSUInteger const kCMDefaultSelected = 0;

@interface CMMNewsfeedVC () <CMTabbarViewDelegate,CMTabbarViewDatasouce,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SideMenuDelegate>

@property (strong, nonatomic) CMTabbarView *tabbarView;
@property (strong, nonatomic) NSArray *datas;

/*@property (strong, nonatomic) NSArray *posts;
 @property (strong, nonatomic) NSArray *filteredPosts;
 @property (strong, nonatomic) NSArray *categories;
 @property (strong, nonatomic) UITableView *table;
 @property (strong, nonatomic) UIRefreshControl *refreshControl;
 @property (strong, nonatomic) UISearchBar *searchBar;
 @property (strong, nonatomic) CLLocationManager *locationManager;
 @property (assign, nonatomic) BOOL isMoreDataLoading;
 @property (assign, nonatomic) int queryNumber;
 @property (assign, nonatomic) BOOL sortByTrending;*/
@end

@implementation CMMNewsfeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self.view insertSubview:self.table belowSubview:self.tabbarView];
    [self.view addSubview:self.tabbarView];
    self.datas = @[@"Recent",@"Immigration",@"Education"];
    //[self.view insertSubview:self.table belowSubview:self.tabbarView];
    //[self.view addSubview:self.tabbarView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.datas = @[@"Recent",@"Immigration",@"Education",@"National Security",@"Local Politics",@"Social Issues",@"Healthcare",@"Criminal Issues"];
        //[self.collectionView reloadData];
        [self.tabbarView reloadData];
        //self.collectionView.contentOffset = CGPointMake(self.view.bounds.size.width*kCMDefaultSelected, 0);
    });
    
    
}

- (void)configureView {
    self.navigationItem.title = @"Newsfeed";
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(didPressFilter:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    NSLog(@"Navigation Bar Height:%f",self.navigationController.navigationBar.frame.size.height);
    self.sortByTrending = NO;
    self.isMoreDataLoading = NO;
    
    // create and populate table view
    NSInteger tabbarBottom = self.navigationController.navigationBar.frame.size.height+ UIApplication.sharedApplication.statusBarFrame.size.height;
    CGRect tableViewFrame = CGRectMake(0,tabbarBottom, self.view.frame.size.width, self.view.frame.size.height-tabbarBottom);
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
   // [self.table setContentOffset:CGPointMake(0, 45) animated:YES];
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 55;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.queryNumber = 20;
    self.categories = [CMMStyles getCategories];
    
    // create side menu
    NewsfeedSideMenuVC *sideMenuVC = self.sideMenuController.rightViewController;
    sideMenuVC.delegate = self;
    sideMenuVC.sortByTrending = self.sortByTrending;
    [self fetchPosts];
    
    // add search bar to table view
    CGRect searchFrame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.view.frame.size.width, 45);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    self.searchBar.delegate = self;
    //[self.table addSubview:self.searchBar];
    self.table.tableHeaderView = self.searchBar;
    [self.view addSubview:self.table];
    //    [self.view insertSubview:self.table belowSubview:_tabbarView];
    //    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.tabbarView.mas_bottom);
    //        make.width.equalTo(@(self.view.frame.size.width));
    //    }];
    
    // add refresh control to table view
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.table insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts {
    [[CMMParseQueryManager shared] fetchPosts:self.queryNumber Categories:self.categories SortByTrending:self.sortByTrending Reported:NO WithCompletion:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            // remove posts from blocked users
            NSMutableArray *tempPosts = [NSMutableArray arrayWithArray:posts];
            NSMutableArray *postsToRemove = [[NSMutableArray alloc] init];
            NSString *blockingKey = [CMMUser.currentUser.objectId stringByAppendingString:@"-blockedUsers"];
            NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
            for (CMMPost *post in tempPosts) {
                for (NSString *blockID in blockedUsers) {
                    if ([post.owner.objectId isEqualToString:blockID]) {
                        [postsToRemove addObject:post];
                        break;
                    }
                }
            }
            for (CMMPost *post in postsToRemove) {
                [tempPosts removeObject:post];
            }
            
            self.posts = tempPosts;
            self.filteredPosts = self.posts;
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
    self.searchBar.backgroundColor = [UIColor whiteColor];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsfeedCell *cell = [[NewsfeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    //NSInteger index = indexPath.row - 1;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 150;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.table.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.table.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.table.isDragging) {
            self.isMoreDataLoading = YES;
            self.queryNumber += 10;
            [self fetchPosts];
        }
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)table editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *report = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Report Post" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to report this post?" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:cancelAction];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CMMPost *post = self.filteredPosts[indexPath.row];
            [[CMMParseQueryManager shared] reportPost:post];
            //[[CMMParseQueryManager shared] addStrikeToUser:post.owner];
        }];
        [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }];
    return [[NSArray alloc] initWithObjects:report, nil];
}

- (void)reloadNewsfeedWithCategories:(NSArray *)categories Trending:(BOOL)trending {
    self.categories = categories;
    self.sortByTrending = trending;
    [self fetchPosts];
    [self.table reloadData];
}
- (CMTabbarView *)tabbarView
{
    if (!_tabbarView) {
        _tabbarView = [[CMTabbarView alloc] initWithFrame:CGRectMake(0, (self.navigationController.navigationBar.frame.size.height+ UIApplication.sharedApplication.statusBarFrame.size.height), self.view.bounds.size.width, 45)];
        _tabbarView.backgroundColor = [UIColor blueColor];
        _tabbarView.delegate = self;
        _tabbarView.dataSource = self;
        _tabbarView.defaultSelectedIndex = kCMDefaultSelected;
        _tabbarView.indicatorScrollType = CMTabbarIndicatorScrollTypeSpring;
        //        _tabbarView.tabPadding = 5.0f;
        //        _tabbarView.selectionType = CMTabbarSelectionBox;
        //_tabbarView.indicatorAttributes = @{CMTabIndicatorColor:[UIColor orangeColor]};
        //_tabbarView.normalAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
        //_tabbarView.selectedAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
        //_tabbarView.needTextGradient = false;
        //[self.view addSubview:_tabbarView];
        
    }
    return _tabbarView;
}


- (NSArray<NSString *> *)tabbarTitlesForTabbarView:(CMTabbarView *)tabbarView
{
    return self.datas;
}

- (void)tabbarView:(CMTabbarView *)tabbarView1 didSelectedAtIndex:(NSInteger)index
{
    if([self.datas[index] isEqual:@"Trending"]){
        self.categories = [CMMStyles getCategories];
        NSLog(@"Category picked:%@", self.categories);
        [self reloadNewsfeedWithCategories:self.categories Trending:YES];
    }
    else if ([self.datas[index] isEqual:@"Recent"]){
        self.categories = [CMMStyles getCategories];
        NSLog(@"Category picked:%@", self.categories);
        [self reloadNewsfeedWithCategories:self.categories Trending:NO];
    }
    else {
        NSArray *categoryPicked = [[NSArray alloc]initWithObjects:self.datas[index], nil];
        NSLog(@"Category picked:%@", categoryPicked);
        [self reloadNewsfeedWithCategories:categoryPicked Trending:NO];
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_tabbarView setTabbarOffsetX:(scrollView.contentOffset.x)/self.view.bounds.size.width];
//}

- (void)fetchNearbyPosts {
    [[CMMParseQueryManager shared] fetchNearbyPosts:0 latitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude withCompletion:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.filteredPosts = posts;
            [self.table reloadData];
        }
    }];
}

- (void) getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Request Authorization
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // Start Updating Location only when user authorized us
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager startUpdatingLocation];
    }
}

@end
