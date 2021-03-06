//
//  CMMNewsfeedVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMNewsfeedVC.h"
#import "CMMProfileVC.h"
#import "CMMChatVC.h"
#import "CMMTopHeadlinesVC.h"
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
#import "CMMModerationController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"


static NSUInteger const kCMDefaultSelected = 0;

@interface CMMNewsfeedVC () <CMTabbarViewDelegate,CMTabbarViewDatasouce,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SideMenuDelegate>

@property (strong, nonatomic) CMTabbarView *tabbarView;
@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) UIView *refreshContainer;
@property (strong, nonatomic) LOTAnimationView *lottieAnimation;
@property (strong, nonatomic) PostDetailsView *modalView;
@property (strong, nonatomic) CMMPost *post;
@property (assign, nonatomic) BOOL NLPFilter;
@property  NSInteger index;


@end

@implementation CMMNewsfeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
    self.view.backgroundColor = [CMMStyles new].globalTan;
    self.navigationController.navigationBar.tintColor = [CMMStyles new].globalNavy;
    self.navigationController.navigationBar.barTintColor = [CMMStyles new].globalTan;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.view addSubview:self.tabbarView];
    
    NSMutableArray *tempCategoryHolder = [[NSMutableArray alloc]initWithObjects:@"Suggested",@"Trending", nil];
    NSArray *temp = [CMMStyles getCategories];
    [tempCategoryHolder addObjectsFromArray:temp];
    self.categories = tempCategoryHolder;
    
    [self reloadNewsfeedWithCategories:self.categories Trending:NO];
    [self.view insertSubview:self.table belowSubview:self.tabbarView];
    //[self.view addSubview:self.tabbarView];
    self.datas = self.categories;
    [self.tabbarView reloadData];
    self.user = CMMUser.currentUser;
}

- (void)createBarButtonItem {
    UIBarButtonItem *viewProfileButton =[[UIBarButtonItem alloc] initWithTitle:@"Moderate" style:UIBarButtonItemStylePlain target:self action:@selector(moderatorMode)];
    viewProfileButton.tintColor = [CMMStyles new].globalNavy;
    self.navigationItem.rightBarButtonItem = viewProfileButton;
}

- (void)moderatorMode {
    CMMModerationController *tabBar = [[CMMModerationController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = tabBar;
}

- (void)configureView {
    self.navigationItem.title = @"Newsfeed";
    
    [self createBarButtonItem];
    
    self.sortByTrending = NO;
    self.isMoreDataLoading = NO;
    
    // create and populate table view
    //NSInteger tabbarBottom = self.navigationController.navigationBar.frame.size.height+ UIApplication.sharedApplication.statusBarFrame.size.height;
    CGRect tableViewFrame = CGRectMake(0,(self.navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication.statusBarFrame.size.height+self.tabbarView.frame.size.height), self.view.frame.size.width, (self.view.frame.size.height-self.tabbarView.frame.size.height-UIApplication.sharedApplication.statusBarFrame.size.height-self.navigationController.navigationBar.frame.size.height));
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.table setContentOffset:CGPointMake(0, 45) animated:YES];
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 55;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [CMMStyles new].globalNavy;
    self.queryNumber = 20;
    self.categories = [CMMStyles getCategories];
    
    
    // add search bar to table view
    CGRect searchFrame = CGRectMake(0, self.table.frame.origin.y+45, self.view.frame.size.width, 45);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    self.searchBar.barTintColor = [CMMStyles new].globalNavy;
    self.searchBar.hidden = YES;
    self.searchBar.delegate = self;
    UITextField *searchBarTextField = (UITextField *)[self.searchBar valueForKey:@"searchField"];
    searchBarTextField.backgroundColor = [CMMStyles new].globalTan;
    searchBarTextField.layer.cornerRadius = 16;
    searchBarTextField.clipsToBounds = YES;
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
    profileButton.tintColor = [CMMStyles new].globalNavy;
    self.navigationItem.leftBarButtonItem = profileButton;
}

-(void)profileButtonTapped {
    // PFUser.current() will now be nil
    CMMProfileVC *profileVC = [[CMMProfileVC alloc]init];
    profileVC.user = CMMUser.currentUser;
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
            if (self.NLPFilter) {
                tempPosts = [NSMutableArray arrayWithArray:[self applyNLPFilter:tempPosts]];
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

- (NSArray *)applyNLPFilter: (NSMutableArray *)unfilteredArray {
    if ([CMMUser.currentUser.interests isEqualToArray:@[]]) {
        return [self filterByKeyword:unfilteredArray];
    } else {
        NSMutableArray *returnArray = [NSMutableArray new];
        int interestAndKeywordIndex = 0;
        int interestOrKeywordIndex = 0;
        for (CMMPost *post in unfilteredArray) {
            BOOL added = NO;
            if ([CMMUser.currentUser.interests containsObject:post.category]) {
                for (NSString *keyword in CMMUser.currentUser.positiveKeyWords) {
                    if ([post.topic containsString:keyword] || [post.detailedDescription containsString:keyword]) {
                        [returnArray insertObject:post atIndex:interestAndKeywordIndex];
                        interestAndKeywordIndex += 1;
                        interestOrKeywordIndex += 1;
                        added = YES;
                    }
                }
                if (!added) {
                    for (NSString *keyword in CMMUser.currentUser.negativeKeyWords) {
                        if ([post.topic containsString:keyword] || [post.detailedDescription containsString:keyword]) {
                            [returnArray insertObject:post atIndex:interestAndKeywordIndex];
                            interestAndKeywordIndex += 1;
                            interestOrKeywordIndex += 1;
                            added = YES;
                        }
                    }
                }
                
                if (!added) {
                    [returnArray insertObject:post atIndex:interestOrKeywordIndex];
                    interestOrKeywordIndex +=1;
                }
            } else {
                BOOL secondAdded = NO;
                if (!added) {
                    for (NSString *keyword in CMMUser.currentUser.positiveKeyWords) {
                        if ([post.topic containsString:keyword] || [post.detailedDescription containsString:keyword]) {
                            [returnArray insertObject:post atIndex:interestOrKeywordIndex];
                            interestOrKeywordIndex += 1;
                            secondAdded = YES;
                        }
                    }
                    if (!added) {
                        for (NSString *keyword in CMMUser.currentUser.negativeKeyWords) {
                            if ([post.topic containsString:keyword] || [post.detailedDescription containsString:keyword]) {
                                [returnArray insertObject:post atIndex:interestOrKeywordIndex];
                                interestOrKeywordIndex += 1;
                                secondAdded = YES;
                            }
                        }
                    }
                }
                if (!secondAdded) {
                    [returnArray addObject:post];
                }
            }
        }
        return returnArray;
    }
}

- (NSMutableArray *)filterByKeyword: (NSMutableArray *)arrayToChange {
    NSMutableArray *returnArray = [NSMutableArray new];
    for (CMMPost *post in arrayToChange) {
        NSLog(@"%@", CMMUser.currentUser.objectId);
        BOOL added = NO;
        for (NSString *keyWord in CMMUser.currentUser.positiveKeyWords) {
            if (([post.topic containsString:keyWord]) || ([post.detailedDescription containsString:keyWord])) {
                if (![returnArray containsObject:post]) {
                    [returnArray addObject:post];
                    added = YES;
                }
                break;
            }
        }
        if (!added) {
            for (NSString *keyword in CMMUser.currentUser.negativeKeyWords) {
                if (([post.topic containsString:keyword]) || ([post.detailedDescription containsString:keyword])) {
                    if (![returnArray containsObject:post]) {
                        [returnArray addObject:post];
                    }
                    break;
                }
            }
        }
    }
    for (CMMPost *post in returnArray) {
        [arrayToChange removeObject:post];
    }
    
    return [NSMutableArray arrayWithArray:[returnArray arrayByAddingObjectsFromArray:arrayToChange]];
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
    [self.searchBar resignFirstResponder];
    self.index = indexPath.row;
    [self presentModalStatusViewForPost:self.filteredPosts[indexPath.row]];
    [self addInterests:self.filteredPosts[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
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
    self.refreshContainer.backgroundColor = [CMMStyles new].globalTan;
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
    
    self.lottieAnimation = [LOTAnimationView animationNamed:@"newsfeed_refresh5"];
    
    self.lottieAnimation.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.lottieAnimation.loopAnimation = YES;
    
    self.lottieAnimation.contentMode = UIViewContentModeScaleAspectFit;
    CGRect lottieRect = CGRectMake(0, 0, (self.refreshContainer.bounds.size.width), (self.refreshContainer.bounds.size.height));
    self.lottieAnimation.frame = lottieRect;
    
    [self.refreshContainer addSubview:self.lottieAnimation];
    
    //    [self.lottieAnimation playFromProgress:0.5 toProgress:1.0 withCompletion:^(BOOL animationFinished) {
    //    }];
    
    [self.lottieAnimation play];
}

-(void)presentModalStatusViewForPost: (CMMPost *)post {
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    self.modalView = [[PostDetailsView alloc]initWithFrame:frame];
    self.post = post;
    BOOL showChatButton = YES;
    NSString *blockingKey = [self.post.owner.objectId stringByAppendingString:@"-blockedUsers"];
    NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
    for (NSString *userID in blockedUsers) {
        if ([userID isEqualToString:CMMUser.currentUser.objectId]) {
            showChatButton = NO;
            break;
        }
    }
    if ([self.post.owner.objectId isEqualToString:CMMUser.currentUser.objectId]) {
        showChatButton = NO;
    }
    if (CMMUser.currentUser.strikes.intValue >= 3) {
        showChatButton = NO;
    }
    
    [self.modalView setPostWithTitle:post.topic category:post.category user:post.owner.username time:[post.createdAt timeAgoSinceNow] description:post.detailedDescription showingChatButton: showChatButton];
    //Report Button
    self.modalView.reportLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *reportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapReport)];
    [self.modalView.reportLabel addGestureRecognizer:reportTap];
    //UserImage
    [self.modalView.userImage setImageWithURL:[NSURL URLWithString:self.post.owner.profileImage.url] placeholderImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    
    self.modalView.userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segueToProfile)];
    [self.modalView.userImage addGestureRecognizer:profileTap];
    //Chat Button
    [self.modalView.chatButton addTarget:self action:@selector(didPressChat) forControlEvents:UIControlEventTouchUpInside];
    //Resources Button
    [self.modalView.resourcesButton addTarget:self action:@selector(didPressResources) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modalView];
}

- (void)segueToProfile {
    CMMProfileVC *profileVC = [[CMMProfileVC alloc] init];
    profileVC.user = self.post.owner;
    [[self navigationController] pushViewController:profileVC animated:YES];
}

- (void)didPressChat {
    [[CMMParseQueryManager shared] conversationWithTopic:self.post.topic postAuthor:self.post.owner withCompletion:^(CMMConversation *chat, NSError *error) {
        CMMChatVC *chatVC = [[CMMChatVC alloc] init];
        chatVC.conversation = chat;
        chatVC.isUserOne = YES;
        [self.post addObject:[NSDate date] forKey:@"userChatTaps"];
        [self.post saveInBackground];
        [[self navigationController] pushViewController:chatVC animated:YES];
    }];
}

- (void)didPressResources {
    CMMTopHeadlinesVC *resourcesVC = [[CMMTopHeadlinesVC alloc]init];
    UINavigationController *resourcesNavigation = [[UINavigationController alloc]initWithRootViewController:resourcesVC];
    //Format post topic for searching
    CMMPost *currentPost = self.filteredPosts[self.index];
    NSString *categoryNoSpaces = [currentPost.topic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *finalCategory = [categoryNoSpaces stringByReplacingOccurrencesOfString:@"\u2019" withString:@"%27"];
    
    resourcesVC.category = finalCategory;
    [self.navigationController pushViewController:resourcesVC animated:YES];
    //[self presentViewController:resourcesVC animated:YES completion:^{}];
    
}
#pragma mark - TabBarView

- (CMTabbarView *)tabbarView
{
    if (!_tabbarView) {
        _tabbarView = [[CMTabbarView alloc] initWithFrame:CGRectMake(0, (self.navigationController.navigationBar.frame.size.height+ UIApplication.sharedApplication.statusBarFrame.size.height), self.view.bounds.size.width, 45)];
        _tabbarView.backgroundColor = [CMMStyles new].globalNavy;
        _tabbarView.delegate = self;
        _tabbarView.dataSource = self;
        _tabbarView.defaultSelectedIndex = 0;
        _tabbarView.indicatorScrollType = CMTabbarIndicatorScrollTypeSpring;
        _tabbarView.indicatorAttributes = @{CMTabIndicatorColor:[CMMStyles new].globalCoral,CMTabIndicatorViewHeight:@(4.0f),CMTabBoxBackgroundColor:[CMMStyles new].globalNavy};
        _tabbarView.normalAttributes = @{NSForegroundColorAttributeName:[CMMStyles new].globalNavy};
        _tabbarView.selectedAttributes = @{NSForegroundColorAttributeName:[CMMStyles new].globalNavy};
        //_tabbarView.defaultSelectedIndex =
        
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
        self.NLPFilter = NO;
        self.categories = [CMMStyles getCategories];
        NSLog(@"Category picked:%@", self.categories);
        [self reloadNewsfeedWithCategories:self.categories Trending:YES];
    }
    else if ([self.datas[index] isEqual:@"Suggested"]){
        self.NLPFilter = YES;
        self.categories = [CMMStyles getCategories];
        NSLog(@"Category picked:%@", self.categories);
        [self reloadNewsfeedWithCategories:self.categories Trending:NO];
    }
    else {
        self.NLPFilter = NO;
        NSArray *categoryPicked = [[NSArray alloc]initWithObjects:self.datas[index], nil];
        NSLog(@"Category picked:%@", categoryPicked);
        [self reloadNewsfeedWithCategories:categoryPicked Trending:NO];
    }
}

- (void)addInterests:(CMMPost *_Nullable)post {
    for (NSString *keyWord in post.keyWords) {
        if (post.overallSentiment) {
            if (![CMMUser.currentUser.positiveKeyWords containsObject:keyWord]) {
                CMMUser.currentUser.positiveKeyWords = [CMMUser.currentUser.positiveKeyWords arrayByAddingObject:keyWord];
            }
        } else {
            if (![CMMUser.currentUser.negativeKeyWords containsObject:keyWord]) {
                CMMUser.currentUser.negativeKeyWords = [CMMUser.currentUser.negativeKeyWords arrayByAddingObject:keyWord];
            }
        }
    }
    [CMMUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"succeeded");
        }
    }];
}

#pragma mark - Extra (Chat)

- (void)didTapReport {
    [[CMMParseQueryManager shared] reportPost:self.post];
    [self.post saveInBackground];
}


#pragma mark - Location-Based Code
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
