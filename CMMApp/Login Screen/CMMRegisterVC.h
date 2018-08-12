//
//  CMMRegisterVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/25/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ParseUI.h"

@interface CMMRegisterVC : UIViewController 

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) UITextField *displayedName;
@property (strong, nonatomic) UITextView *profileBio;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) PFImageView *originalProfileImage;
@property (strong, nonatomic) UILabel *tapPhotoLabel;
@property (strong,nonatomic) PFImageView *imageFile;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UITableView *tableViewOne;
@property (strong, nonatomic) UITableView *tableViewTwo;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UILabel * voterQuestion;
@property (strong, nonatomic) UISwitch * voterSwitch;

@end
