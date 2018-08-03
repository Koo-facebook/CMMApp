//
//  PostDetailVC.h
//  CMMApp
//
//  Created by Olivia Jorasch on 7/20/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMPost.h"

@interface PostDetailVC : UIViewController
- (void)configureDetails:(CMMPost *)post;
@property (strong, nonatomic) CMMPost *post;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *reportLabel;
@property (strong, nonatomic) UIImageView *authorImage;
@property (strong, nonatomic) UIButton *chatButton;
@property (strong, nonatomic) UIButton *resourceButton;
@end
