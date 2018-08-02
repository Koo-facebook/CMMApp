//
//  CMMIconView.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMIconView.h"

@implementation CMMIconView

//Initalize our object with a icon photo and label
-(instancetype)initWithIcon:(UIImageView *)icon title:(UILabel *)titleLabel {
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = titleLabel;
    }
    return self;
}

@end
