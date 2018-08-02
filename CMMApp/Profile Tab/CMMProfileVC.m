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
#import "CMMUser.h"
#import "NewsfeedCell.h"
#import "Masonry.h"
#import "PostDetailVC.h"
#import "CMMParseQueryManager.h"

@interface CMMProfileVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *profileFeed;

@end

@implementation CMMProfileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerClass:[NewsfeedCell class] forCellReuseIdentifier:@"feedCell"];

    self.profileFeed = [[NSArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Profile";
    
    if (!self.user) {
        self.user = PFUser.currentUser;
    }
    
    [self createName];
    [self createBio];
    [self createTableView];
    if ([self.user.objectId isEqualToString:CMMUser.currentUser.objectId]) {
        [self createEditProfileButton];
    }
    [self createProfileImage];
    
    //Layout
    [self updateConstraints];
    
    [self fetchPosts];
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
    
    // TableView
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.profileBioLabel.mas_bottom).offset(20);
      make.bottom.equalTo(self.view.mas_bottom);
      make.width.equalTo(@(self.view.frame.size.width));
        
    }];

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

- (void)editButtonTapped {
    CMMEditProfileVC *editProfileVC = [[CMMEditProfileVC alloc]init];
    UINavigationController *editProfileNavigation = [[UINavigationController alloc]initWithRootViewController:editProfileVC];
    [self presentViewController:editProfileNavigation animated:YES completion:^{}];
}

- (void) fetchPosts {
    [[CMMParseQueryManager shared] fetchPosts:20 ByAuthor:self.user WithCompletion:^(NSArray *posts, NSError *error) {
        if (posts) {
            self.profileFeed = posts;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NewsfeedCell *cell = [[NewsfeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    CMMPost *post = self.profileFeed[indexPath.row];
    //NSLog(@"😎😎😎%@", post);
    [cell configureCell:post];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileFeed.count;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     PostDetailVC *detailVC = [[PostDetailVC alloc] init];
     CMMPost *post = self.profileFeed[indexPath.row];
     [detailVC configureDetails:post];
     [[self navigationController] pushViewController:detailVC animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
