//
//  CMMModerationController.m
//  CMMApp
//
//  Created by Olivia Jorasch on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMModerationController.h"
#import "CMMModeratorInboxVC.h"
#import "CMMModeratorFeedVC.h"

@interface CMMModerationController ()

@end

@implementation CMMModerationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    CMMModeratorFeedVC *feedVC = [[CMMModeratorFeedVC alloc] init];
    UINavigationController *feedNavVC = [[UINavigationController alloc] initWithRootViewController:feedVC];
    feedNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Posts" image:nil tag:0];
    [viewControllers addObject:feedNavVC];
    
    CMMModeratorInboxVC *inboxVC = [[CMMModeratorInboxVC alloc] init];
    UINavigationController *inboxNavVC = [[UINavigationController alloc] initWithRootViewController:inboxVC];
    inboxNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chats" image:nil tag:0];
    [viewControllers addObject:inboxNavVC];
    
    self.viewControllers = viewControllers;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
