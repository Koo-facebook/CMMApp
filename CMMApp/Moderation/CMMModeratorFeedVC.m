//
//  CMMModeratorFeedVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 8/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMModeratorFeedVC.h"
#import "CMMParseQueryManager.h"
#import "CMMStyles.h"

@interface CMMModeratorFeedVC ()
@end

@implementation CMMModeratorFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Reported Posts";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPosts {
    [[CMMParseQueryManager shared] fetchPosts:self.queryNumber Categories:self.categories SortByTrending:NO Reported:YES WithCompletion:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            self.filteredPosts = self.posts;
            [self.table reloadData];
            [self.refreshControl endRefreshing];
            if (self.filteredPosts.count == self.queryNumber) {
                self.isMoreDataLoading = NO;
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)table editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMPost *post = self.posts[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"Reports: %@", post.reportedNumber];
    UITableViewRowAction *reports = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    return [[NSArray alloc] initWithObjects:reports, nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
