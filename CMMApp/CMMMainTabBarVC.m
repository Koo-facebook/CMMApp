//
//  CMMMainTabBarVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMMainTabBarVC.h"

@interface CMMMainTabBarVC ()

@end

@implementation CMMMainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    CMMTimelineVC *timelineVC = [[CMMTimelineVC alloc] init];
    timelineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Timeline" image:nil tag:0];
    [viewControllers addObject:timelineVC];
    
    CMMEventsVC *eventsVC = [[CMMEventsVC alloc] init];
    eventsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:nil tag:1];
    [viewControllers addObject:eventsVC];
    
    CMMInboxVC *inboxVC = [[CMMInboxVC alloc] init];
    inboxVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:2];
    [viewControllers addObject:inboxVC];
    
    CMMProfileVC *profileVC = [[CMMProfileVC alloc] init];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil tag:3];
    [viewControllers addObject:profileVC];
    
    self.viewControllers = [viewControllers copy];
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
