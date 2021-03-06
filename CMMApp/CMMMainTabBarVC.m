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

-(void)viewDidLoad {
    //First View Controller
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    //self.tabBar.barTintColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0) green:(CGFloat)(194.0/255.0) blue:(CGFloat)(77.0/255.0) alpha:1];
    CMMBounceAnimation *bounceAnimation = [[CMMBounceAnimation alloc] init];
    bounceAnimation.textSelectedColor = [CMMStyles new].globalBurgundy;
    bounceAnimation.iconSelectedColor = [CMMStyles new].globalBurgundy;
    
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
    

    NewsfeedSideMenuVC *sideMenuVC = [[NewsfeedSideMenuVC alloc] init];
    LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:firstNav leftViewController:nil rightViewController:sideMenuVC];
    sideMenuController.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    sideMenuController.rightViewWidth = 2*self.view.frame.size.width/3;
    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;
    sideMenuController.tabBarItem = firstTabBarItem;
    

    // Second ViewController
    CMMBounceAnimation *bounceAnimation_two = [[CMMBounceAnimation alloc] init];
    bounceAnimation_two.textSelectedColor = [CMMStyles new].globalBurgundy;
    bounceAnimation_two.iconSelectedColor = [CMMStyles new].globalBurgundy;
    
    CMMAnimatedBarItem *secondTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Event" image:[UIImage imageNamed:@"icon_pinmap"] selectedImage:nil];
    secondTabBarItem.animation = bounceAnimation_two;
    secondTabBarItem.textColor = [UIColor blackColor];
    UIImageView *secondIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pinmap"]];
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"Rotation Animation";
    secondTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:secondIconView title:secondLabel];
    
    CMMEventsVC *secondViewController = [[CMMEventsVC alloc] init];
    //UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    secondViewController.tabBarItem = secondTabBarItem;
    
    //Third View Controller
    CMMBounceAnimation *bounceAnimation_three = [[CMMBounceAnimation alloc] init];
    bounceAnimation_three.textSelectedColor = [CMMStyles new].globalBurgundy;
    bounceAnimation_three.iconSelectedColor = [CMMStyles new].globalBurgundy;
    
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
    rotationAnimation.textSelectedColor = [CMMStyles new].globalBurgundy;
    rotationAnimation.iconSelectedColor = [CMMStyles new].globalBurgundy;
    
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
    //fourthNav.tabBarItem.badgeValue = @"2";
    
    //Fifth View Controller
    CMMBounceAnimation *bounceAnimation_four = [[CMMBounceAnimation alloc] init];
    bounceAnimation_four.textSelectedColor = [CMMStyles new].globalBurgundy;
    bounceAnimation_four.iconSelectedColor = [CMMStyles new].globalBurgundy;
    
    CMMAnimatedBarItem *fifthTabBarItem = [[CMMAnimatedBarItem alloc] initWithTitle:@"Resources" image:[UIImage imageNamed:@"icon_book"] selectedImage:nil];
    fifthTabBarItem.animation = bounceAnimation_four;
    fifthTabBarItem.textColor = [UIColor blackColor];
    UIImageView *fifthIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_book"]];
    UILabel *fifthLabel = [[UILabel alloc] init];
    fifthLabel.text = @"Bounce Animation";
    fifthTabBarItem.iconView = [[CMMIconView alloc]initWithIcon:fifthIconView title:fifthLabel];
    CMMResourcesVC *fifthViewController = [[CMMResourcesVC alloc] init];
    UINavigationController *fifthNav = [[UINavigationController alloc] initWithRootViewController:fifthViewController];
    fifthNav.tabBarItem = fifthTabBarItem;
    

    self.viewControllers = @[sideMenuController, secondViewController, thirdNav, fourthNav, fifthNav];
    
    [super viewDidLoad];
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
