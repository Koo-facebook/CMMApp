//
//  NewsfeedCell.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "NewsfeedCell.h"
#import <DateTools.h>
#import "Masonry.h"

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
    
    self.post = post;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = post.topic;
    [self.contentView addSubview:titleLabel];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [post.createdAt timeAgoSinceNow];
    dateLabel.textColor = [UIColor colorWithRed:54/255.f green:173/255.f blue:157/255.f alpha:1];
    [self.contentView addSubview:dateLabel];
    [dateLabel setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = post.category;
    categoryLabel.textColor = [UIColor colorWithRed:54/255.f green:173/255.f blue:157/255.f alpha:1];
    [self.contentView addSubview:categoryLabel];
    [categoryLabel setFont:[UIFont systemFontOfSize:10]];
    
    // Autolayout for the labels
    UIEdgeInsets titlePadding = UIEdgeInsetsMake(28, 12, 12, 12);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(titlePadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(titlePadding.left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-titlePadding.bottom);
        make.right.equalTo(self.contentView.mas_right).with.offset(-titlePadding.right);
    }];
    UIEdgeInsets categoryPadding = UIEdgeInsetsMake(12, 12, 12, 12);
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(categoryPadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(categoryPadding.left);
        make.width.equalTo(@(categoryLabel.intrinsicContentSize.width));
    }];
    UIEdgeInsets datePadding = UIEdgeInsetsMake(12, 12, 12, 12);
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(datePadding.top);
        make.left.equalTo(categoryLabel.mas_right).with.offset(datePadding.left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-datePadding.right);
    }];
    
}
@end
