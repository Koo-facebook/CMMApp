//
//  CMMItemAnimation.h
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CMMItemAnimationProtocol <NSObject>

// Following functions are set in children of ItemAnimation, but should be avaliable for all VC to use
- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel;
- (void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel defaultTextColor:(UIColor *)defaultTextColor;
- (void)selectedState:(UIImageView *)icon textLabel:(UILabel *)textLabel;

@end

@interface CMMItemAnimation : NSObject <CMMItemAnimationProtocol>

// Assigning duration to be a characteristic of CMMItemAnimation
@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) UIColor *textSelectedColor;
@property (strong, nonatomic) UIColor *iconSelectedColor;

@end
