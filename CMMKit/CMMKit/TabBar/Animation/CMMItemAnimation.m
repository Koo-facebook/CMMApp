//
//  CMMItemAnimation.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMItemAnimation.h"

@implementation CMMItemAnimation

-(instancetype) init {
    self = [super init];
    if (self) {
        //Set the length of the animation
        self.duration = 0.5;
        //Color of text when icon selected
        self.textSelectedColor = [UIColor purpleColor];
    }
    return self;
}

-(void)playAnimation:(id)icon textLabel:(id)textLabel {
    //Refer to Animation File (either Bounce or Rotate)
}

-(void)deselectAnimation:(id)icon textLabel:(id)textLabel defaultTextColor:(id)defaultTextColor {
    //Refer to Animation File (either Bounce or Rotate)
}

-(void)selectedState:(id)icon textLabel:(id)textLabel barItemBKG: (UIColor *)color{
    //Refer to Animation File (either Bounce or Rotate)
}

@end
