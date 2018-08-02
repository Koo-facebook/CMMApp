//
//  CMMStyles.h
//  CMMApp
//
//  Created by Olivia Jorasch on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMMStyles : NSObject

+ (UIColor *)getTealColor;
+ (UIFont *)getTitleFontWithSize: (CGFloat)size;
+ (UIFont *)getTextFontWithSize:(CGFloat)size;
+ (NSArray *)getCategories;

@end
