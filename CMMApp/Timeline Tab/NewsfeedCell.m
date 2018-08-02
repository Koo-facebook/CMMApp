//
//  NewsfeedCell.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "NewsfeedCell.h"
#import <DateTools.h>
#import <Masonry.h>
#import "CMMStyles.h"

@interface NewsfeedCell ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak,nonatomic) IBOutlet UIImageView *profileImage;

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


//-(void)customInit {
//    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
//    UINib *nibName = [UINib nibWithNibName:@"PostTableViewCell" bundle:bundle ];
//    self.contentView = [[nibName instantiateWithOwner:self options:nil] firstObject];
//
//    self.contentView.center = self.center;
//    self.contentView.autoresizingMask = UIViewAutoresizingNone;
//    self.contentView.frame = self.bounds;
//
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.clipsToBounds = YES;
//    self.contentView.layer.cornerRadius = 5;
//
//    self.titleLabel.text = @"";
//    self.categoryLabel.text = @"";
//    self.usernameLabel.text = @"";
//    self.timeLabel.text = @"";
//    self.profileImage.image = nil;
//
//    [self addSubview:self.contentView];
//
//}
//
//-(void)setPostCellWithPost: (CMMPost *)post{
//
//    [self customInit];
//    self.titleLabel.text = post.topic;
//    self.categoryLabel.text = post.category;
//    self.usernameLabel.text = post.owner.username;
//    self.timeLabel.text = [NSDate shortTimeAgoSinceDate:post.createdAt];
//
//    self.profileImage.image = nil ;
//}

- (void)configureCell:(CMMPost *)post {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = post.topic;
    [self.contentView addSubview:titleLabel];
    [titleLabel setFont:[CMMStyles getTextFontWithSize:14]];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [NSDate shortTimeAgoSinceDate:post.createdAt];
    dateLabel.textColor = [CMMStyles getTealColor];
    [self.contentView addSubview:dateLabel];
    [dateLabel setFont:[CMMStyles getTitleFontWithSize:18 ]];

    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = post.category;
    categoryLabel.textColor = [CMMStyles getTealColor];
    [self.contentView addSubview:categoryLabel];
    [categoryLabel setFont:[CMMStyles getTitleFontWithSize:18]];

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
