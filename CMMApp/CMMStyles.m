//
//  CMMStyles.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMStyles.h"

@implementation CMMStyles

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.globalTan = [UIColor colorWithRed:239.0/255.0 green:235/255.0 blue:233/255.0 alpha:1.0];
        self.globalLightBlue = [UIColor colorWithRed:196/255.0 green:236/255.0 blue:255/255.0 alpha:1.0];
        self.globalNavy = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0];
        self.globalCoral = [UIColor colorWithRed:224/255.0 green:82/255.0 blue:99/255.0 alpha:1.0];
        self.globalBurgundy = [UIColor colorWithRed:114/255.0 green:17/255.0 blue:33/255.0 alpha:1.0];
    }
    return self;
}

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
    NSArray *array = @[@"Social Issues",@"Education", @"Criminal Issues", @"Economics", @"Elections", @"Environment", @"Foreign Policy", @"Healthcare", @"Immigration", @"Local Politics", @"National Security"];
    return array;
}

@end
