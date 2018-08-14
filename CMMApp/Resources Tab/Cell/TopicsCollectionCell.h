//
//  TopicsCollectionCell.h
//  CMMApp
//
//  Created by Keylonnie Miller on 7/25/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMArticle.h"

@interface TopicsCollectionCell : UICollectionViewCell


@property (strong, nonatomic) UIImageView *categoryIcon;
@property (strong, nonatomic) UIView *cellInfoView;
@property (strong, nonatomic, nullable) UIColor *textColor;
@property (strong, nonatomic) UILabel *category;
@property (strong, nonatomic, nullable) UIFont *text;

- (void)configureCollectionCell: (NSString *)category;

@end
