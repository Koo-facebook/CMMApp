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
#import "CMMModeratorPostVC.h"

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMModeratorPostVC *detailVC = [[CMMModeratorPostVC alloc] init];
    CMMPost *post = self.filteredPosts[indexPath.row];
    [detailVC configureDetails:post];
    [[self navigationController] pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
