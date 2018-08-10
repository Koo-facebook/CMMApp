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
#import "CMMEventsVC.h"
#import "CMMNewsfeedVC.h"
#import <CMMKit/CMMBounceAnimation.h>
#import <CMMKit/RotationAnimation.h>
#import <CMMKit/CMMAnimatedBarItem.h>
#import <CMMKit/CMMIconView.h>

@interface CMMModerationController ()

@end

@implementation CMMModerationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tabBar.barTintColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0) green:(CGFloat)(194.0/255.0) blue:(CGFloat)(77.0/255.0) alpha:1];
    // First ViewController
    CMMBounceAnimation *bounceAnimation = [[CMMBounceAnimation alloc] init];
    bounceAnimation.textSelectedColor = [UIColor blueColor];
    bounceAnimation.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *firstTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Posts" image:[UIImage imageNamed:@"icon_home"] selectedImage:nil];
    firstTabBarItem.animation = bounceAnimation;
    firstTabBarItem.textColor = [UIColor blackColor];
    UIImageView *firstIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home"]];
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"Bounce Animation";
    firstTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:firstIconView title:firstLabel];
    
    CMMModeratorFeedVC *firstViewController = [[CMMModeratorFeedVC alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    firstNav.tabBarItem = firstTabBarItem;
    
    // Second ViewController
    RotationAnimation *rotationAnimation = [[RotationAnimation alloc] init];
    rotationAnimation.textSelectedColor = [UIColor blueColor];
    rotationAnimation.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *secondTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Chats" image:[UIImage imageNamed:@"icon_user"] selectedImage:nil];
    secondTabBarItem.animation = rotationAnimation;
    secondTabBarItem.textColor = [UIColor blackColor];
    UIImageView *secondIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user"]];
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"Rotation Animation";
    secondTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:secondIconView title:secondLabel];
    
    CMMModeratorInboxVC *secondViewController = [[CMMModeratorInboxVC alloc] init];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    secondNav.tabBarItem = secondTabBarItem;
    
    self.viewControllers = @[firstNav, secondNav];
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
