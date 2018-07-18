//
//  CMMMainTabBarVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMMainTabBarVC.h"
#import "CMMComposerVC.h"

@interface CMMMainTabBarVC ()

@end

@implementation CMMMainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    CMMNewsfeedVC *newsfeedVC = [[CMMNewsfeedVC alloc] init];
    newsfeedVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Newsfeed" image:nil tag:0];
    [viewControllers addObject:newsfeedVC];
    
    CMMEventsVC *eventsVC = [[CMMEventsVC alloc] init];
    UINavigationController *eventsNavigation = [[UINavigationController alloc]initWithRootViewController:eventsVC];
    eventsNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:nil tag:1];
    [viewControllers addObject:eventsNavigation];
    
    CMMInboxVC *inboxVC = [[CMMInboxVC alloc] init];
    inboxVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:2];
    [viewControllers addObject:inboxVC];
    
    CMMProfileVC *profileVC = [[CMMProfileVC alloc] init];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil tag:3];
    [viewControllers addObject:profileVC];
    
    CMMComposerVC *composeVC = [[CMMComposerVC alloc] init];
    composeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil tag:4];
    [viewControllers addObject:composeVC];
    
    self.viewControllers = [viewControllers copy];
}


@end
