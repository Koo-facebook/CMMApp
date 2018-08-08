//
//  AboutViewCell.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewCell : UICollectionViewCell


@property (strong, nonatomic, nullable) UIColor *textColor;

@property (strong, nonatomic, nullable) UIFont *textFont;

@property (strong, nonatomic, nullable) UIColor *selectedTextColor;

@property (strong, nonatomic, nullable) UIFont *selectedTextFont;

@property (nonatomic, copy, nullable) NSString *title;

@end
