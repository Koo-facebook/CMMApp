//
//  NewsfeedCell.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "NewsfeedCell.h"
#import <DateTools.h>
#import "Masonry.h"
#import "CMMStyles.h"

@interface NewsfeedCell ()

@property (strong,nonatomic) UIView *cellInfoView;
@property (strong, nonatomic) CMMPost *post;


@end

@implementation NewsfeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureCell:(CMMPost *)post {
    
    //self.contentView.backgroundColor = [UIColor colorWithRed:(CGFloat)(245.0/255.0) green:(CGFloat)(247.0/255.0) blue:(CGFloat)(248.0/255.0) alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [CMMStyles new].globalNavy;;
    
    self.cellInfoView = [[UIView alloc]init];//WithFrame:CGRectMake(10, 10, (self.contentView.frame.size.width), 110)];
    [self.contentView addSubview:self.cellInfoView];
    
    self.post = post;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [CMMStyles new].globalNavy;
    titleLabel.text = post.topic;
    //titleLabel.font = [UIFont fontWithName:@"Prata" size:14];
    [self.cellInfoView addSubview:titleLabel];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [post.createdAt timeAgoSinceNow];
    dateLabel.textColor = [CMMStyles new].globalNavy;
    [self.cellInfoView addSubview:dateLabel];
    [dateLabel setFont:[UIFont systemFontOfSize:10]];
    
    UIImageView *categoryIcon = [[UIImageView alloc] init];
    NSString *text = post.category;
    NSString *name = [text stringByAppendingString:@"_icon"];
    //NSLog(@"%@", name);
    categoryIcon.image = [UIImage imageNamed:name];
    [self.cellInfoView addSubview:categoryIcon];
    
    UILabel *categoryLabel = [[UILabel alloc]init];
    categoryLabel.text = post.category;
    categoryLabel.textColor = [CMMStyles new].globalNavy;
    [self.contentView addSubview:categoryLabel];
    [categoryLabel setFont:[UIFont systemFontOfSize:16]];
    
    // Autolayout for the labels
    UIEdgeInsets containerPadding = UIEdgeInsetsMake(10, 10, 5, 10);
    [self.cellInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(containerPadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(containerPadding.left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-containerPadding.bottom);
        make.right.equalTo(self.contentView.mas_right).with.offset(-containerPadding.right);
    }];
    
    UIEdgeInsets categoryTitlePadding = UIEdgeInsetsMake(5, 5, 5, 5);
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryIcon.mas_right).offset(categoryTitlePadding.left);
        make.height.equalTo(@(categoryLabel.intrinsicContentSize.height));
        make.width.equalTo(@(categoryLabel.intrinsicContentSize.width));
        make.centerY.equalTo(categoryIcon.mas_centerY);
    }];
    
    UIEdgeInsets titlePadding = UIEdgeInsetsMake(10, 12, 12, 12);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(categoryIcon.mas_bottom).offset(titlePadding.top);
        make.left.equalTo(self.cellInfoView.mas_left).with.offset(titlePadding.left);
        make.bottom.equalTo(self.cellInfoView.mas_bottom).with.offset(-titlePadding.bottom);
        make.right.equalTo(self.cellInfoView.mas_right).with.offset(-titlePadding.right);
    }];
    
    UIEdgeInsets categoryPadding = UIEdgeInsetsMake(5, 5, 5, 5);
    [categoryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellInfoView.mas_top).with.offset(categoryPadding.top);
        make.left.equalTo(self.cellInfoView.mas_left).with.offset(categoryPadding.left);
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
    }];
    
    UIEdgeInsets datePadding = UIEdgeInsetsMake(12, 54, 12, 12);
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellInfoView.mas_top).with.offset(datePadding.top);
        //make.left.equalTo(categoryLabel.mas_right).with.offset(datePadding.left);
        make.right.equalTo(self.cellInfoView.mas_right).with.offset(-datePadding.right);
    }];
    
    self.cellInfoView.backgroundColor = [CMMStyles new].globalTan;
    //self.cellInfoView.backgroundColor = [UIColor colorWithRed:(CGFloat)(77.0/255.0) green:(CGFloat)(179.0/255.0) blue:(CGFloat)(179.0/255.0) alpha:1];
    self.cellInfoView.layer.cornerRadius = 10;
    self.cellInfoView.clipsToBounds = YES;
    
    //[self.cellInfoView.layer setBorderColor:[UIColor blackColor].CGColor];
    //[self.cellInfoView.layer setBorderWidth:2.0f];
}
@end

