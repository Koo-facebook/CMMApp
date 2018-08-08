//
//  CMMTopHeadlinesVC.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/7/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMTopHeadlinesVC : UIViewController <UITableViewDelegate, UITableViewDataSource >

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *category;

@end
