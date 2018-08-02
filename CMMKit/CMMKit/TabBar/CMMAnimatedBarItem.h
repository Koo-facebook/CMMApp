//
//  CMMAnimatedBarItem.h
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMIconView.h"
#import "CMMItemAnimation.h"

@interface CMMAnimatedBarItem : UITabBarItem

@property (nonatomic, strong) CMMItemAnimation *animation;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) CMMIconView *iconView;

- (void)playAnimationForItem;
- (void)deselectAnimationForItem;
- (void)selectedStateForItem;

@end
