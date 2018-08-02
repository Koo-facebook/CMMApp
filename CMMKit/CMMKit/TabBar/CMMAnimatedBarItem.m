//
//  CMMAnimatedBarItem.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMAnimatedBarItem.h"

@implementation CMMAnimatedBarItem

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
