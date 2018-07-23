//
//  CMMProfileVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMProfileVC.h"
#import "CMMPost.h"
#import "CMMUser.h"
#import "NewsfeedCell.h"
#import "Masonry.h"

@interface CMMProfileVC ()

@property (strong, nonatomic) NSArray *profileFeed;

@end

@implementation CMMProfileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Profile";
    [self createName];
    [self createBio];
    [self createTableView];
    [self createEditProfileButton];
    [self createProfileImage];
    
    //Layout
    [self updateConstraints];
}

- (void)updateConstraints {
    
    // Username Label
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.superview.mas_top).offset(100);
        make.centerX.equalTo(self.usernameLabel.superview.mas_centerX);
        make.height.equalTo(@(self.usernameLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.usernameLabel.intrinsicContentSize.width));
    }];
    
    // Profile Image
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(35);
        make.centerX.equalTo(self.profileImage.superview.mas_centerX);
        make.width.equalTo(@(200));
        make.height.equalTo(@(200));
    }];
    
    
    // Profile Bio Label
    [self.profileBioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.mas_bottom).offset(20);
        make.centerX.equalTo(self.profileBioLabel.superview.mas_centerX);
        make.width.equalTo(@(300));
        //make.height.equalTo(@(self.profileBioLabel.intrinsicContentSize.height));
    }];
    
    // TableView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileBioLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.tableView.superview.mas_centerX);
        make.width.equalTo(@(self.tableView.intrinsicContentSize.width));
        make.height.equalTo(@(self.tableView.intrinsicContentSize.height));
    }];
    
    // Edit Profile Button
    [self.editProfileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileBioLabel.mas_bottom).offset(18);
        make.centerX.equalTo(self.profileBioLabel.superview.mas_centerX);
        make.width.equalTo(@(self.editProfileButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.editProfileButton.intrinsicContentSize.height));
    }];
}

-(void) createName{
    PFUser * user = PFUser.currentUser;
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.textColor = [UIColor blackColor];
    self.usernameLabel.font = [UIFont fontWithName:@"Arial" size:26];
    self.usernameLabel.numberOfLines = 1;
    self.usernameLabel.text = user.username;
    [self.view addSubview:self.usernameLabel];
}

-(void) createProfileImage {
    self.profileImage = [[PFImageView alloc] init];
    self.profileImage.backgroundColor = [UIColor blackColor];
    // CONVERT TO BE VIEWED
    //Crop profile image to a circle
    // self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    // self.profileImage.clipsToBounds = YES;
    [self.view addSubview:self.profileImage];
}

-(void) createBio {
    //PFUser * user = PFUser.currentUser;
    self.profileBioLabel = [[UILabel alloc] init];
    self.profileBioLabel.textColor = [UIColor blackColor];
    self.profileBioLabel.font = [UIFont fontWithName:@"Arial" size:16];
    //self.profileBioLabel.text = user[@"profileBio"];
    self.profileBioLabel.numberOfLines = 0;
    self.profileBioLabel.text = @"Here is where a profile bio would go. More about the person, perhaps including there interests.";
    
    [self.view addSubview:self.profileBioLabel];
}


// Create Add to Calendar Button
- (void)createEditProfileButton {
    self.editProfileButton = [[UIButton alloc] init];
    [self.editProfileButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editProfileButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.editProfileButton.titleLabel.font = [UIFont systemFontOfSize:18];
    //[self.addToCalendarButton addTarget:self action:@selector(addToCalendarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editProfileButton];
}

/*- (void) fetchPosts {
 // construct PFQuery
 PFQuery *postQuery = [CMMPost query];
 [postQuery orderByDescending:@"createdAt"];
 [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
 postQuery.limit = 20;
 
 // fetch data asynchronously
 [postQuery findObjectsInBackgroundWithBlock:^(NSArray<CMMPost *> * _Nullable posts, NSError * _Nullable error) {
 if (posts) {
 // do something with the data fetched
 self.profileFeed = posts;
 [self.tableView reloadData];
 }
 else {
 // handle error
 NSLog(@"%@", error.localizedDescription);
 }
 }];
 }*/

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 100;
    
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsfeedCell *cell = [[NewsfeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postsCell"];
    
    //[cell configureCell: self.]
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileFeed.count;
}
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 CMMEventDetailsVC *eventDetailsVC = [[CMMEventDetailsVC alloc]init];
 eventDetailsVC.event = self.eventList[indexPath.row];
 [self presentViewController:eventDetailsVC animated:YES completion:^{}];
 }*/
@end
