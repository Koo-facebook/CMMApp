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
@end
