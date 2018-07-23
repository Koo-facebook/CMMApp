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
@property (strong, nonatomic) UITextField *profileBio;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UILabel *tapPhotoLabel;

@end
