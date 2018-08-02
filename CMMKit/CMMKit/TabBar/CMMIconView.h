//
//  CMMIconView.h
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMMIconView : NSObject

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIView *tabIndicator;

-(instancetype)initWithIcon:(UIImageView *)icon title:(UILabel *)titleLabel;

@end
