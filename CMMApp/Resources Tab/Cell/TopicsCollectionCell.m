//
//  TopicsCollectionCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/25/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TopicsCollectionCell.h"
#import "Masonry.h"
#import "CMMStyles.h"

@interface TopicsCollectionCell ()

@end

@implementation TopicsCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:self.contentView.bounds];
    //[self configureCollectionCell];
    //NSLog(@"Category in CC: %@", self.title);

    return self;
}


- (void)configureCollectionCell: (NSString *)category {
    //self.backgroundColor = [UIColor purpleColor];
    
    self.cellInfoView = [[UIView alloc]init];
    [self.contentView addSubview:self.cellInfoView];

    //Set category name
    self.category = [[UILabel alloc]init];
    self.category.text = category;
    self.category.numberOfLines = 1;
    self.category.textColor = [CMMStyles new].globalNavy;
    [self.cellInfoView addSubview:self.category];

    //Set icon image
    self.categoryIcon = [[UIImageView alloc] init];
    NSString *text = category;
    NSString *name = [text stringByAppendingString:@"_icon"];
    //NSLog(@"%@", name);
    self.categoryIcon.image = [UIImage imageNamed:name];
    [self.cellInfoView addSubview:self.categoryIcon];

    // Autolayout for the labels
    UIEdgeInsets containerPadding = UIEdgeInsetsMake(10, 10, 5, 10);
    [self.cellInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);//.with.offset(containerPadding.left);
        make.bottom.equalTo(self.contentView.mas_bottom);//.with.offset(-containerPadding.bottom);
        make.right.equalTo(self.contentView.mas_right);//.with.offset(-containerPadding.right);
    }];
    
    [self.categoryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellInfoView.mas_top).offset(35);
        make.width.equalTo(@(75));
        make.height.equalTo(self.categoryIcon.mas_width);
        make.centerX.equalTo(self.cellInfoView.mas_centerX);
    }];

    UIEdgeInsets titlePadding = UIEdgeInsetsMake(12, 5, 10, 12);
    [self.category mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryIcon.mas_bottom).offset(20);
        make.centerX.equalTo(self.cellInfoView.mas_centerX);
        //make.bottom.equalTo(self.cellInfoView.mas_bottom).offset(-5);
        make.width.equalTo(@(self.category.intrinsicContentSize.width));
        //make.height.equalTo(@(self.cellInfoView.intrinsicContentSize.height));
    }];

    self.cellInfoView.backgroundColor = [CMMStyles new].globalTan;
    self.cellInfoView.layer.cornerRadius = 10;
    self.cellInfoView.clipsToBounds = YES;

    //[self.cellInfoView.layer setBorderColor:[UIColor blackColor].CGColor];
    //[self.cellInfoView.layer setBorderWidth:2.0f];
}

@end
