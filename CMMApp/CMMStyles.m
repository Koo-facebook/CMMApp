//
//  CMMStyles.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMStyles.h"

@implementation CMMStyles

+ (UIColor *)getTealColor {
    return [UIColor colorWithRed:54/255.f green:173/255.f blue:157/255.f alpha:1];
}

+ (UIFont *)getFontWithSize:(CGFloat)size Weight:(UIFontWeight)weight {
    return [UIFont systemFontOfSize:size weight:weight];
}

+ (NSArray *)getCategories {
    NSArray *array = @[@"Economics", @"Immigration", @"Healthcare", @"Another Category", @"Also this one!"];
    return array;
}

@end
