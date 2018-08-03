//
//  CMMNewsfeedVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CMMParseQueryManager.h"
#import "CMMConversation.h"

@interface CMMNewsfeedVC : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *filteredPosts;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int queryNumber;
@property (assign, nonatomic) BOOL sortByTrending;
@end
