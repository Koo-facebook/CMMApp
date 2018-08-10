//
//  CMMNewsfeedVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMNewsfeedVC.h"
#import "CMMProfileVC.h"
#import "CMMPost.h"
#import "NewsfeedCell.h"
#import "Masonry.h"
#import "PostDetailVC.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "NewsfeedSideMenuVC.h"
#import "CMMStyles.h"
#import "CMTabbarView.h"
#import <CMMKit/PostDetailsView.h>
#import <Lottie/Lottie.h>
#import "Datetools.h"

static NSUInteger const kCMDefaultSelected = 0;

@interface CMMNewsfeedVC () <CMTabbarViewDelegate,CMTabbarViewDatasouce,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SideMenuDelegate>

@property (strong, nonatomic) CMTabbarView *tabbarView;
@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) UIView *refreshContainer;
@property (strong, nonatomic) LOTAnimationView *lottieAnimation;
@property (strong, nonatomic) PostDetailsView *modalView;


@end

@implementation CMMNewsfeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self.view addSubview:self.tabbarView];
    
    NSMutableArray *tempCategoryHolder = [[NSMutableArray alloc]initWithObjects:@"Trending",@"Recent", nil];
    NSArray *temp = [CMMStyles getCategories];
    [tempCategoryHolder addObjectsFromArray:temp];
    self.categories = tempCategoryHolder;
    
    [self reloadNewsfeedWithCategories:self.categories Trending:YES];
    [self.view insertSubview:self.table belowSubview:self.tabbarView];
    //[self.view addSubview:self.tabbarView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.datas = self.categories;
        [self.tabbarView reloadData];
        //self.table.contentOffset = CGPointMake(self.view.bounds.size.width*kCMDefaultSelected, 0);
    });
    self.user = PFUser.currentUser;
}

- (void)createBarButtonItem {
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(didPressFilter:)];
    self.navigationItem.rightBarButtonItem = filterButton;
}

- (void)configureView {
    self.navigationItem.title = @"Newsfeed";
    
    //[self createBarButtonItem];

    self.sortByTrending = NO;
    self.isMoreDataLoading = NO;
    
    // create and populate table view
    //NSInteger tabbarBottom = self.navigationController.navigationBar.frame.size.height+ UIApplication.sharedApplication.statusBarFrame.size.height;
    CGRect tableViewFrame = CGRectMake(0,(self.navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication.statusBarFrame.size.height+self.tabbarView.frame.size.height), self.view.frame.size.width, (self.view.frame.size.height-self.tabbarView.frame.size.height));
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.table setContentOffset:CGPointMake(0, 45) animated:YES];
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 55;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.queryNumber = 20;
    self.categories = [CMMStyles getCategories];
    

    // add search bar to table view
    CGRect searchFrame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y+45, self.view.frame.size.width, 45);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    self.searchBar.hidden = YES;
    self.searchBar.delegate = self;
    //[self.table addSubview:self.searchBar];
    self.table.tableHeaderView = self.searchBar;
    [self.view addSubview:self.table];

    // add refresh control to table view
    self.refreshControl = [[UIRefreshControl alloc] init];//WithFrame:customRefreshControlFrame];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.table insertSubview:self.refreshControl atIndex:0];
    

    [self createProfileButton];
}

// Create Profile Button
- (void)createProfileButton {
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonTapped)];
    self.navigationItem.leftBarButtonItem = profileButton;
}

-(void)profileButtonTapped {
        // PFUser.current() will now be nil
        CMMProfileVC *profileVC = [[CMMProfileVC alloc]init];
        profileVC.user = PFUser.currentUser;
        [[self navigationController] pushViewController:profileVC animated:YES];
}

//QUERY CODE
- (void)fetchPosts {
    [[CMMParseQueryManager shared] setUserStrikes:CMMUser.currentUser sender:self];
    [[CMMParseQueryManager shared] fetchPosts:self.queryNumber Categories:self.categories SortByTrending:self.sortByTrending Reported:NO WithCompletion:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            // remove posts from blocked users
            NSMutableArray *tempPosts = [NSMutableArray arrayWithArray:posts];
            NSMutableArray *postsToRemove = [[NSMutableArray alloc] init];
            NSLog(@"OBJECTID: %@", self.user.objectId);
            NSLog(@"PFOBJECTID: %@", PFUser.currentUser.objectId);
            NSString *blockingKey = [self.user.objectId stringByAppendingString:@"-blockedUsers"];
            NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
            for (CMMPost *post in tempPosts) {
                for (NSString *blockID in blockedUsers) {
                    if ([post.owner.objectId isEqualToString:blockID]) {
                        [postsToRemove addObject:post];
                        NSLog(@"POSTS TO REMOVE: %@", postsToRemove);
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

- (void)reloadNewsfeedWithCategories:(NSArray *)categories Trending:(BOOL)trending {
    self.categories = categories;
    self.sortByTrending = trending;
    [self fetchPosts];
    [self.table reloadData];
}

- (void)didPressFilter:(id)sender {
    [self.sideMenuController showRightViewAnimated];
}

//SEARCH BAR CODE
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
    [self.table setContentOffset:CGPointMake(0, 45) animated:YES];
    [self.searchBar resignFirstResponder];
}

//TABLEVIEW CODE
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
//    PostDetailVC *detailVC = [[PostDetailVC alloc] init];
//    CMMPost *post = self.filteredPosts[indexPath.row];
//    [detailVC configureDetails:post];
//    [[self navigationController] pushViewController:detailVC animated:YES];
    [self presentModalStatusViewForPost:self.filteredPosts[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //When scrolling starts, present search bar
    self.searchBar.hidden = NO;
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
    self.refreshContainer = [[UIView alloc]init];//WithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.refreshControl.frame.size.width, (self.refreshControl.frame.size.height+(self.table.contentSize.height - self.table.bounds.size.height)))];
        self.refreshContainer.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor clearColor];
        [self.refreshControl addSubview:self.refreshContainer];
    
    [self.refreshContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabbarView.mas_bottom);
        make.width.equalTo(self.refreshContainer.superview.mas_width);
        make.bottom.equalTo(self.table.mas_top).offset(-25);
    }];
    [self presentRefreshView];
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

-(void)presentRefreshView {
    
    self.lottieAnimation = [LOTAnimationView animationNamed:@"newsfeed_refresh"];
    
    self.lottieAnimation.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.lottieAnimation.loopAnimation = YES;
    
    self.lottieAnimation.contentMode = UIViewContentModeScaleAspectFit;
    CGRect lottieRect = CGRectMake(0, 0, (self.refreshContainer.bounds.size.width), (self.refreshContainer.bounds.size.height));
    self.lottieAnimation.frame = lottieRect;
    
    [self.refreshContainer addSubview:self.lottieAnimation];
//    [self.lottieAnimation playFromProgress:0.0 toProgress:0.8 withCompletion:^(BOOL animationFinished) {
//        if (animationFinished) {
//            [self.animationContainer removeFromSuperview];
//            CMMMainTabBarVC *tabBarVC = [[CMMMainTabBarVC alloc] init];
//            [self presentViewController:tabBarVC animated:YES completion:^{}];
//        }
//    }];
    [self.lottieAnimation play];
    //
    //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeSelf:) userInfo:nil repeats:false];
}

-(void)presentModalStatusViewForPost: (CMMPost *)post {
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    self.modalView = [[PostDetailsView alloc]initWithFrame:frame];
    
    [self.modalView setPostWithTitle:post.topic category:post.category user:post.owner.username time:[post.createdAt timeAgoSinceNow] description:post.detailedDescription];
    
    [self.view addSubview:self.modalView];
}
//TOP TABBAR CODE
- (CMTabbarView *)tabbarView
{
    if (!_tabbarView) {
        _tabbarView = [[CMTabbarView alloc] initWithFrame:CGRectMake(0, (self.navigationController.navigationBar.frame.size.height+ UIApplication.sharedApplication.statusBarFrame.size.height), self.view.bounds.size.width, 45)];
        _tabbarView.backgroundColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0) green:(CGFloat)(194.0/255.0) blue:(CGFloat)(77.0/255.0) alpha:1];
        _tabbarView.delegate = self;
        _tabbarView.dataSource = self;
        _tabbarView.defaultSelectedIndex = kCMDefaultSelected;
        _tabbarView.indicatorScrollType = CMTabbarIndicatorScrollTypeSpring;
        //_tabbarView.indicatorAttributes = @{CMTabIndicatorColor:[UIColor orangeColor]};
        //_tabbarView.normalAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
        //_tabbarView.selectedAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor]};

        
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

//LOCATION-BASED CODE

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
