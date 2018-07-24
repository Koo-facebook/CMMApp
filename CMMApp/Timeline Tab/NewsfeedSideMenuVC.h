//
//  NewsfeedSideMenuVC.h
//  CMMApp
//
//  Created by Olivia Jorasch on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsfeedSideMenuVC : UIViewController
@property (strong, nonatomic) NSArray *categoryArray;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *selectedCategories;
@end
