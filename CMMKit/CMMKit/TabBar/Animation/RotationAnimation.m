//
//  RotationAnimation.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/30/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "RotationAnimation.h"

@implementation RotationAnimation


- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel
{
    [self playRoatationAnimation:icon];
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
        icon.tintColor = self.textSelectedColor;
    }
}

- (void)playRoatationAnimation:(UIImageView *)icon
{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = @0.0;
    
    CGFloat toValue = (CGFloat)(M_PI * 2.0);

    rotateAnimation.toValue = @(toValue);
    rotateAnimation.duration = (NSTimeInterval)self.duration;
    
    [icon.layer addAnimation:rotateAnimation forKey:@"rotation360"];
    
    UIImage *iconImage = icon.image;
    if (iconImage) {
        UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        icon.image = renderImage;
        icon.tintColor = self.iconSelectedColor;
    }
}

@end
