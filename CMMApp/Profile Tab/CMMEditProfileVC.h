//
//  CMMEditProfileVC.h
//  CMMApp
//
//  Created by Keylonnie Miller on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@interface CMMEditProfileVC : UIViewController

@property (strong, nonatomic) UITextField *displayedName;
@property (strong, nonatomic) UITextView *profileBio;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) PFImageView *originalProfileImage;
@property (strong, nonatomic) UILabel *tapPhotoLabel;
@property (strong,nonatomic) PFImageView *imageFile;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *submitButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UILabel * voterQuestion;
@property (strong, nonatomic) UISwitch * voterSwitch;

@end
