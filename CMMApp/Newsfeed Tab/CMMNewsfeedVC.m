//
//  CMMNewsfeedVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMNewsfeedVC.h"
#import "CMMPost.h"

@interface CMMNewsfeedVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation CMMNewsfeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    self.view.backgroundColor = [UIColor purpleColor];
    self.navigationItem.title = @"Newsfeed";
    
    // create and populate table view
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self fetchPosts];
    
    // add refresh control to table view
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.table insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"CMMPost"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"owner"];
    [query includeKey:@"question"];
    [query includeKey:@"categories"];
    [query includeKey:@"content"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.table reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"%@", posts);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CMMPost *post = self.posts[indexPath.row];
    cell.textLabel.text = post.question;
    NSLog(@"%@", post.question);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
