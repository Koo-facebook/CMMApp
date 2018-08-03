//
//  InterestsViewCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "InterestsViewCell.h"
#import "NewsfeedCell.h"
#import "CMMUser.h"
#import "CMMPost.h"
#import "PostDetailVC.h"
#import "Parse.h"
#import "CMMParseQueryManager.h"

@interface InterestsViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *profileFeed;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, weak) CMMUser *user;

@end
@implementation InterestsViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
        [self fetchPosts];
    }
    return self;
}
- (void) fetchPosts {
    [[CMMParseQueryManager shared] fetchPosts:20 ByAuthor:self.user WithCompletion:^(NSArray *posts, NSError *error) {
        if (posts) {
            self.profileFeed = posts;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self fetchPosts];
    [self addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsfeedCell *cell = [[NewsfeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    CMMPost *post = self.profileFeed[indexPath.row];
    //NSLog(@"😎😎😎%@", post);
    [cell configureCell:post];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileFeed.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostDetailVC *detailVC = [[PostDetailVC alloc] init];
    CMMPost *post = self.profileFeed[indexPath.row];
    [detailVC configureDetails:post];
    //[[self navigationController] pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
