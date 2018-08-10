//
//  CMMAnimatedBarItem.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMAnimatedBarItem.h"
#import "CMMBadge.h"

@interface CMMAnimatedBarItem ()
@property (strong, nonatomic) CMMBadge *badge;
@end

@implementation CMMAnimatedBarItem

- (NSString *)badgeValue
{
    if (self.badge) {
        return self.badge.text;
    }
    return nil;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    if (badgeValue == nil) {
        if (self.badge) {
            [self.badge removeFromSuperview];
            self.badge = nil;
        }
        return ;
    }
    
    if (self.badge == nil) {
        self.badge = [CMMBadge badge];
        
        UIView *containerView = self.iconView.icon.superview;
        if (containerView) {
            [self.badge addBadgeToTabItemView:containerView];
        }
    }
    
    if (self.badge) {
        self.badge.text = badgeValue;
    }
}

-(void)playAnimationForItem {
    //Make sure there is an animation for the TabBarItem
    NSAssert(self.animation !=nil, @"MISSING ANIMATION -- Add animation to TabBarItem");
    
    //Check that there is an animation and iconview before continuing
    if (self.animation !=nil && self.iconView !=nil) {
        [self.animation playAnimation:self.iconView.icon textLabel:self.iconView.title];
    }
}

-(void)deselectAnimationForItem {
    //Check that there is an animation and iconview before continuing
    if (self.animation !=nil && self.iconView !=nil) {
        [self.animation deselectAnimation:self.iconView.icon textLabel:self.iconView.title defaultTextColor:self.textColor];
    }
}

-(void)selectedStateForItem {
    //Check that there is an animation and iconview before continuing
    if (self.animation !=nil && self.iconView !=nil) {
        [self.animation selectedState:self.iconView.icon textLabel:self.iconView.title];
        
    }
}

@end
