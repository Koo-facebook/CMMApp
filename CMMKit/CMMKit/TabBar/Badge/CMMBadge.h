//
//  CMMBadge.h
//  CMMKit
//
//  Created by Keylonnie Miller on 8/9/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMBadge : UILabel

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, strong) UILabel *numberLabel;

+(CMMBadge *)badge;
-(void)addBadgeToTabItemView: (UIView *)view ;

@end
