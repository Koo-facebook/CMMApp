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

+ (UIFont *)getTitleFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Prata" size:size];
}

+ (UIFont *)getTextFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Montserrat" size:size];
}
+ (NSArray *)getCategories {
    NSArray *array = @[@"Recent",@"Trending",@"Social Issues",@"Education", @"Criminal Issues", @"Economics", @"Elections", @"Environment", @"Foreign Policy", @"Healthcare", @"Immigration", @"Local Politics", @"National Security", ];
    return array;
}

@end
