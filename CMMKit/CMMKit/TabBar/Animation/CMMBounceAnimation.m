//
//  CMMBounceAnimation.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/30/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMBounceAnimation.h"

@implementation CMMBounceAnimation

- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel
{
    [self playBounceAnimation:icon];
    textLabel.textColor = self.textSelectedColor;
}

- (void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel defaultTextColor:(UIColor *)defaultTextColor
{
    textLabel.textColor = defaultTextColor;
    
    UIImage *iconImage = icon.image;
    if (iconImage) {
        UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        icon.image = renderImage;
        icon.tintColor = defaultTextColor;
    }
}

- (void)selectedState:(UIImageView *)icon textLabel:(UILabel *)textLabel
{
    textLabel.textColor = self.textSelectedColor;
    
    UIImage *iconImage = icon.image;
    if (iconImage) {
        UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        icon.image = renderImage;
        icon.tintColor = self.iconSelectedColor;
    }
}

- (void)playBounceAnimation:(UIImageView *)icon
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@1.0, @1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = (NSTimeInterval)self.duration;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    
    [icon.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    UIImage *iconImage = icon.image;
    if (iconImage) {
        UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        icon.image = renderImage;
        icon.tintColor = self.iconSelectedColor;
    }
}

@end
