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
#import "Masonry.h"

@interface InterestsViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *profileFeed;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end
@implementation InterestsViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        if (!self.user) {
        //            self.user = PFUser.currentUser;
        //        }
        NSLog(@"User in Interest Cell:%@", self.user);
        //[self createScrollView];
        [self createTableView];
        [self fetchPosts];
        self.userInteractionEnabled = YES;
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
//Create ScrollView
-(void)createScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.scrollEnabled = YES;
    [self addSubview:self.scrollView];
}

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(5, 5, (self.frame.size.width-10), (self.frame.size.height-20));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
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
    NSLog(@"CELL SELECTED");
    //[[self navigationController] pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
