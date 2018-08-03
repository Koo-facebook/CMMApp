//
//  CMMProfileVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMProfileVC.h"
#import "CMMEditProfileVC.h"
#import "CMMPost.h"
#import "AppDelegate.h"
#import "CMMLoginVC.h"
#import "CMMUser.h"
#import "NewsfeedCell.h"
#import "Masonry.h"
#import "PostDetailVC.h"
#import "CMMParseQueryManager.h"
#import "Parse.h"
#import "CMTabbarView.h"
#import "ProfileCell.h"

static NSUInteger const kCMDefaultSelected = 0;

@interface CMMProfileVC () <CMTabbarViewDelegate,CMTabbarViewDatasouce,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CMTabbarView *tabbarView;
@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) UIView *container;

@property (strong, nonatomic) NSArray *profileFeed;

@end

@implementation CMMProfileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // [self.tableView registerClass:[NewsfeedCell class] forCellReuseIdentifier:@"feedCell"];

    self.profileFeed = [[NSArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Profile";
    
    if (!self.user) {
        self.user = PFUser.currentUser;
    }
    
    [self createName];
    [self createBio];
   //[self createTableView];
    if ([self.user.objectId isEqualToString:CMMUser.currentUser.objectId]) {
        [self createEditProfileButton];
        [self createLogoutButton];
    } else {
        [self createBlockButton];
    }
    [self createProfileImage];
    
    //self.datas = @[@"About Me",@"My Posts"];
    self.container = [[UIView alloc]init];
    [self.container insertSubview:self.collectionView belowSubview:self.tabbarView];
    [self.container addSubview:self.tabbarView];
    [self.view addSubview:self.container];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.datas = @[@"About Me",@"My Posts"];
        [self.collectionView reloadData];
        [self.tabbarView reloadData];
        self.collectionView.contentOffset = CGPointMake(self.view.bounds.size.width*kCMDefaultSelected, 0);
    });
    
    //Layout
    [self updateConstraints];
    //[self fetchPosts];
}

- (CMTabbarView *)tabbarView
{
    if (!_tabbarView) {
        _tabbarView = [[CMTabbarView alloc] initWithFrame:CGRectMake(0, 0, (self.view.bounds.size.width-95), 40)];
        _tabbarView.delegate = self;
        _tabbarView.dataSource = self;
        _tabbarView.backgroundColor = [UIColor blueColor];
        _tabbarView.defaultSelectedIndex = kCMDefaultSelected;
        _tabbarView.indicatorScrollType = CMTabbarIndicatorScrollTypeSpring;
        //_tabbarView.tabPadding = 5.0f;
        //        _tabbarView.selectionType = CMTabbarSelectionBox;
        _tabbarView.indicatorAttributes = @{CMTabIndicatorColor:[UIColor greenColor]};
        //_tabbarView.normalAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
        //_tabbarView.selectedAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
        //_tabbarView.needTextGradient = false;
    }
   return _tabbarView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((self.view.bounds.size.width-95), (250));
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGRect frameCollect = CGRectMake(0, 0, (self.view.bounds.size.width-95), 250);
        _collectionView = [[UICollectionView alloc] initWithFrame:frameCollect collectionViewLayout:layout];
        [_collectionView registerClass:[ProfileCell class] forCellWithReuseIdentifier:NSStringFromClass([ProfileCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = true;
        _collectionView.pagingEnabled = true;
        _collectionView.contentOffset = CGPointMake(self.view.bounds.size.width*kCMDefaultSelected, 0);
        _collectionView.backgroundColor = [UIColor lightGrayColor];
    }
    return _collectionView;
}

- (NSArray<NSString *> *)tabbarTitlesForTabbarView:(CMTabbarView *)tabbarView
{
    return self.datas;
}

- (void)tabbarView:(CMTabbarView *)tabbarView1 didSelectedAtIndex:(NSInteger)index
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        ProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ProfileCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.title = PFUser.currentUser[@"profileBio"];
    }
    else{
            cell.title = [NSString stringWithFormat:@"%ld",indexPath.row];
        }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tabbarView setTabbarOffsetX:(scrollView.contentOffset.x)/self.view.bounds.size.width];
}

- (void)updateConstraints {

    // Username Label
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.mas_bottom).offset(15);
        make.centerX.equalTo(self.usernameLabel.superview.mas_centerX);
        make.height.equalTo(@(self.usernameLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.usernameLabel.intrinsicContentSize.width));
    }];

    // Profile Image
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.profileImage.superview.mas_centerX);
        make.width.equalTo(@(150));
        make.height.equalTo(@(150));
        //Crop profile image to a circle

    }];

    // Profile Bio Label
    [self.profileBioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.usernameLabel.superview.mas_centerX);
        make.width.equalTo(@(325));
        //make.height.equalTo(@(self.profileBioLabel.intrinsicContentSize.height));
    }];

    // TabBarView
  [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.profileBioLabel.mas_bottom).offset(20);
      make.centerX.equalTo(self.container.superview.mas_centerX);
      make.height.equalTo(@(40));
      make.width.equalTo(@(self.view.bounds.size.width-95));
    }];
    
    // CollectionView
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_tabbarView.mas_bottom).offset(20);
//        make.centerX.equalTo(_collectionView.superview.mas_centerX);
//        make.height.equalTo(@(250));
//        make.width.equalTo(@(self.view.bounds.size.width-95));
//    }];
}

-(void) createName{
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.textColor = [UIColor blackColor];
    self.usernameLabel.font = [UIFont fontWithName:@"Arial" size:26];
    self.usernameLabel.numberOfLines = 1;
    self.usernameLabel.text = self.user[@"displayedName"];
    [self.view addSubview:self.usernameLabel];
}

-(void) createProfileImage {
    self.profileImage = [[PFImageView alloc] init];
    self.profileImage.backgroundColor = [UIColor blackColor];
    
    self.profileImage.file = self.user[@"profileImage"];
    [self.profileImage loadInBackground];
    
    self.profileImage.frame = CGRectMake(self.profileImage.frame.origin.x, self.profileImage.frame.origin.y, 150, 150);
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = YES;
    [self.view addSubview:self.profileImage];
}

-(void) createBio {
    self.profileBioLabel = [[UILabel alloc] init];
    self.profileBioLabel.textColor = [UIColor blackColor];
    self.profileBioLabel.font = [UIFont fontWithName:@"Arial" size:16];
    //self.profileBioLabel.text = user[@"profileBio"];
    self.profileBioLabel.numberOfLines = 0;
    //self.profileBioLabel.backgroundColor = [UIColor purpleColor];
    self.profileBioLabel.text = self.user[@"profileBio"];
    
    [self.view addSubview:self.profileBioLabel];
}

// Create Edit Profile Button
- (void)createEditProfileButton {
    self.editProfileButton = [[UIButton alloc] init];
    [self.editProfileButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editProfileButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.editProfileButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.editProfileButton addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editProfileButton];
    
    // Layout
    [self.editProfileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editProfileButton.superview.mas_top).offset(100);
        make.right.equalTo(self.editProfileButton.superview.mas_rightMargin).offset(10);
        // make.centerX.equalTo(self.profileBioLabel.superview.mas_centerX);
        make.width.equalTo(@(self.editProfileButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.editProfileButton.intrinsicContentSize.height));
    }];
}


// Create Logout Button
- (void)createLogoutButton {
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped)];
    self.navigationItem.rightBarButtonItem = logoutButton;
}

-(void)logoutButtonTapped {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        CMMLoginVC *loginViewController = [[CMMLoginVC alloc]init];
        appDelegate.window.rootViewController = loginViewController;
    }];
}


- (void)createBlockButton {
    self.editProfileButton = [[UIButton alloc] init];
    [self.editProfileButton setTitle:@"Block User" forState:UIControlStateNormal];
    [self.editProfileButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.editProfileButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.editProfileButton addTarget:self action:@selector(blockButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editProfileButton];
    
    // Layout
    [self.editProfileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editProfileButton.superview.mas_top).offset(100);
        make.right.equalTo(self.editProfileButton.superview.mas_rightMargin).offset(10);
        // make.centerX.equalTo(self.profileBioLabel.superview.mas_centerX);
        make.width.equalTo(@(self.editProfileButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.editProfileButton.intrinsicContentSize.height));
    }];
}

- (void)blockButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to block this user?" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMMParseQueryManager shared] addBlockedUser:self.user Sender:self];
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
    return;
}

- (void)editButtonTapped {
    CMMEditProfileVC *editProfileVC = [[CMMEditProfileVC alloc]init];
    UINavigationController *editProfileNavigation = [[UINavigationController alloc]initWithRootViewController:editProfileVC];
    [self presentViewController:editProfileNavigation animated:YES completion:^{}];
}


@end
