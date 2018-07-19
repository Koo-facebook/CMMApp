//
//  NewsfeedCell.h
//  CMMApp
//
//  Created by Olivia Jorasch on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMPost.h"

@interface NewsfeedCell : UITableViewCell
@property (strong, nonatomic) CMMPost *post;
- (void)configureCell:(CMMPost *)post;
@end
