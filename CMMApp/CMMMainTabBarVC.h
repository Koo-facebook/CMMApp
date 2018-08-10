//
//  CMMMainTabBarVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

//FrameWorks
#import <UIKit/UIKit.h>
#import <CMMKit/CMMKit.h>

//Tab Bar Files
#import <CMMKit/CMMTabBar.h>
#import <CMMKit/CMMAnimatedBarItem.h>
#import <CMMKit/CMMIconView.h>

// Animations
#import <CMMKit/CMMBounceAnimation.h>
#import <CMMKit/RotationAnimation.h>

//View Controllers
#import "CMMNewsfeedVC.h"
#import "CMMInboxVC.h"
#import "CMMProfileVC.h"
#import "CMMTopHeadlinesVC.h"
#import "CMMEventsVC.h"
#import "CMMResourcesVC.h"
#import "CMMComposerVC.h"

#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "NewsfeedSideMenuVC.h"

@interface CMMMainTabBarVC : CMMTabBar

@end
