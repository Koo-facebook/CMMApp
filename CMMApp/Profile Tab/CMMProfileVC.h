//
//  CMMProfileVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "CMMUser.h"

@interface CMMProfileVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PFImageView *profileImage;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIButton *editProfileButton;
@property (strong, nonatomic) UIButton *logoutButton;
@property (strong, nonatomic) UILabel *profileBioLabel;
@property (nonatomic, weak) CMMUser *user;
@property (nonatomic, weak) NSArray *interests;

@end
