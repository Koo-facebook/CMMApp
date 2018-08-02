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

-(void)viewDidLoad {
    //First View Controller
    CMMBounceAnimation *bounceAnimation = [[CMMBounceAnimation alloc] init];
    bounceAnimation.textSelectedColor = [UIColor blueColor];
    bounceAnimation.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *firstTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"icon_home"] selectedImage:nil];
    firstTabBarItem.animation = bounceAnimation;
    firstTabBarItem.textColor = [UIColor blackColor];
    UIImageView *firstIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home"]];
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"Bounce Animation";
    firstTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:firstIconView title:firstLabel];
    CMMNewsfeedVC *firstViewController = [[CMMNewsfeedVC alloc] init];
    //self.view.tintColor = [UIColor blueColor];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    firstNav.tabBarItem = firstTabBarItem;
    
    // Second ViewController
    CMMBounceAnimation *bounceAnimation_two = [[CMMBounceAnimation alloc] init];
    bounceAnimation_two.textSelectedColor = [UIColor blueColor];
    bounceAnimation_two.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *secondTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Event" image:[UIImage imageNamed:@"icon_pinmap"] selectedImage:nil];
    secondTabBarItem.animation = bounceAnimation_two;
    secondTabBarItem.textColor = [UIColor blackColor];
    UIImageView *secondIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pinmap"]];
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"Rotation Animation";
    secondTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:secondIconView title:secondLabel];
    
    CMMEventsVC *secondViewController = [[CMMEventsVC alloc] init];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    secondNav.tabBarItem = secondTabBarItem;
    
    //Third View Controller
    CMMBounceAnimation *bounceAnimation_three = [[CMMBounceAnimation alloc] init];
    bounceAnimation_three.textSelectedColor = [UIColor blueColor];
    bounceAnimation_three.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *thirdTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Post" image:[UIImage imageNamed:@"icon_post"] selectedImage:nil];
    thirdTabBarItem.animation = bounceAnimation_three;
    thirdTabBarItem.textColor = [UIColor blackColor];
    UIImageView *thirdIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_post"]];
    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.text = @"Bounce Animation";
    thirdTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:thirdIconView title:thirdLabel];
    CMMComposerVC *thirdViewController = [[CMMComposerVC alloc] init];
    UINavigationController *thirdNav = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    thirdNav.tabBarItem = thirdTabBarItem;
    
    
    // Fourth ViewController
    RotationAnimation *rotationAnimation = [[RotationAnimation alloc] init];
    rotationAnimation.textSelectedColor = [UIColor blueColor];
    rotationAnimation.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *fourthTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Inbox" image:[UIImage imageNamed:@"icon_user"] selectedImage:nil];
    fourthTabBarItem.animation = rotationAnimation;
    fourthTabBarItem.textColor = [UIColor blackColor];
    UIImageView *fourthIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user"]];
    UILabel *fourthLabel = [[UILabel alloc] init];
    fourthLabel.text = @"Rotation Animation";
    fourthTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:fourthIconView title:fourthLabel];
    
    CMMInboxVC *fourthViewController = [[CMMInboxVC alloc] init];
    UINavigationController *fourthNav = [[UINavigationController alloc] initWithRootViewController:fourthViewController];
    fourthNav.tabBarItem = fourthTabBarItem;
    
    //Fifth View Controller
    CMMBounceAnimation *bounceAnimation_four = [[CMMBounceAnimation alloc] init];
    bounceAnimation_four.textSelectedColor = [UIColor blueColor];
    bounceAnimation_four.iconSelectedColor = [UIColor blueColor];
    
    CMMAnimatedBarItem *fifthTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Resources" image:[UIImage imageNamed:@"icon_book"] selectedImage:nil];
    fifthTabBarItem.animation = bounceAnimation_four;
    fifthTabBarItem.textColor = [UIColor blackColor];
    UIImageView *fifthIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_book"]];
    UILabel *fifthLabel = [[UILabel alloc] init];
    fifthLabel.text = @"Bounce Animation";
    fifthTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:fifthIconView title:fifthLabel];
    CMMProfileVC *fifthViewController = [[CMMProfileVC alloc] init];
    UINavigationController *fifthNav = [[UINavigationController alloc] initWithRootViewController:fifthViewController];
    fifthNav.tabBarItem = fifthTabBarItem;
    
    
    self.viewControllers = @[firstNav, secondNav, thirdNav, fourthNav, fifthNav];
    
    [super viewDidLoad];
}

//- (UIImage *)resizeImageToIcon:(UIImage *)image {
//    CGSize size = CGSizeMake(25, 25);
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

@end
