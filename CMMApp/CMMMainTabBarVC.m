//
//  CMMMainTabBarVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMMainTabBarVC.h"
#import "CMMComposerVC.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "NewsfeedSideMenuVC.h"

@interface CMMMainTabBarVC ()

@end

@implementation CMMMainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    CMMNewsfeedVC *newsfeedVC = [[CMMNewsfeedVC alloc] init];
    UINavigationController *feedNavVC = [[UINavigationController alloc] initWithRootViewController:newsfeedVC];
    NewsfeedSideMenuVC *sideMenuVC = [[NewsfeedSideMenuVC alloc] init];
    LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:feedNavVC leftViewController:nil rightViewController:sideMenuVC];
    sideMenuController.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    sideMenuController.rightViewWidth = 200;
    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;
    sideMenuController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Newsfeed" image:nil tag:0];
    [viewControllers addObject:sideMenuController];
    
    CMMResourcesVC *eventsVC = [[CMMResourcesVC alloc] init];
    UINavigationController *eventsNavigation = [[UINavigationController alloc]initWithRootViewController:eventsVC];
    eventsNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:nil tag:1];
    [viewControllers addObject:eventsNavigation];
    
    CMMComposerVC *composeVC = [[CMMComposerVC alloc] init];
    UINavigationController *composeNavVC = [[UINavigationController alloc] initWithRootViewController:composeVC];
    composeNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Compose" image:nil tag:4];
    [viewControllers addObject:composeNavVC];
    
    CMMInboxVC *inboxVC = [[CMMInboxVC alloc] init];
    UINavigationController *inboxNavVC = [[UINavigationController alloc] initWithRootViewController:inboxVC];
    inboxNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:2];
    [viewControllers addObject:inboxNavVC];
    
    CMMProfileVC *profileVC = [[CMMProfileVC alloc] init];
    UINavigationController *profileNavVC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil tag:3];
    [viewControllers addObject:profileNavVC];
    
    
    self.viewControllers = [viewControllers copy];
}


@end
