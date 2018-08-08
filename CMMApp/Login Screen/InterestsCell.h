//
//  InterestsCell.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMRegisterVC.h"

@interface InterestsCell : UITableViewCell

@property (strong, nonatomic) UILabel *title;

-(void)configureInterestsCell:(NSString *)cellTitle;

@end
