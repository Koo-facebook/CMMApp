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
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    CMMNewsfeedVC *newsfeedVC = [[CMMNewsfeedVC alloc] init];
    UINavigationController *feedNavVC = [[UINavigationController alloc] initWithRootViewController:newsfeedVC];
    NewsfeedSideMenuVC *sideMenuVC = [[NewsfeedSideMenuVC alloc] init];
    LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:feedNavVC leftViewController:nil rightViewController:sideMenuVC];
    sideMenuController.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    sideMenuController.rightViewWidth = 2*newsfeedVC.view.frame.size.width/3;
    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;
    sideMenuController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Newsfeed" image:nil tag:0];
    [viewControllers addObject:sideMenuController];
    [sideMenuController.tabBarItem setImage:[self resizeImageToIcon:[UIImage imageNamed:@"feedTab"]]];
    
    CMMResourcesVC *eventsVC = [[CMMResourcesVC alloc] init];
    UINavigationController *eventsNavigation = [[UINavigationController alloc]initWithRootViewController:eventsVC];
    eventsNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:nil tag:1];
    [viewControllers addObject:eventsNavigation];
    [eventsNavigation.tabBarItem setImage:[self resizeImageToIcon:[UIImage imageNamed:@"eventsTab"]]];
    
    CMMComposerVC *composeVC = [[CMMComposerVC alloc] init];
    UINavigationController *composeNavVC = [[UINavigationController alloc] initWithRootViewController:composeVC];
    composeNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Compose" image:nil tag:4];
    [viewControllers addObject:composeNavVC];
    [composeNavVC.tabBarItem setImage:[self resizeImageToIcon:[UIImage imageNamed:@"composeTab"]]];
    
    CMMInboxVC *inboxVC = [[CMMInboxVC alloc] init];
    UINavigationController *inboxNavVC = [[UINavigationController alloc] initWithRootViewController:inboxVC];
    inboxNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:2];
    [viewControllers addObject:inboxNavVC];
    [inboxNavVC.tabBarItem setImage:[self resizeImageToIcon:[UIImage imageNamed:@"inboxTab"]]];
    
    CMMProfileVC *profileVC = [[CMMProfileVC alloc] init];
    UINavigationController *profileNavVC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil tag:3];
    [viewControllers addObject:profileNavVC];
    [profileNavVC.tabBarItem setImage:[self resizeImageToIcon:[UIImage imageNamed:@"profileTab"]]];
    
    self.viewControllers = [viewControllers copy];
}

- (UIImage *)resizeImageToIcon:(UIImage *)image {
    CGSize size = CGSizeMake(25, 25);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
