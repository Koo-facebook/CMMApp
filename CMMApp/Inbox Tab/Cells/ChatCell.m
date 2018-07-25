//
//  ChatCell.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()

@property (nonatomic, assign) BOOL isIncoming;

@end

@implementation ChatCell

- (void)showIncomingMessage {

    self.chatMessageContent = [UILabel new];
    self.chatMessageContent.numberOfLines = 0;
    self.chatMessageContent.font = [UIFont systemFontOfSize:18];
    self.chatMessageContent.textColor = [UIColor whiteColor];
    self.chatMessageContent.text = self.message.content;
    
    CGSize constraintRect = CGSizeMake(0.66 * self.contentView.frame.size.width, CGFLOAT_MAX);
    
    CGRect boundingBox = [self.message.content boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.chatMessageContent.font} context:nil];
    
    self.chatMessageContent.frame = CGRectMake(0, 0, ceil(boundingBox.size.width), ceil(boundingBox.size.height));
    
    CGSize bubbleSize = CGSizeMake(self.chatMessageContent.frame.size.width + 28, self.chatMessageContent.frame.size.height + 28);
    
    self.chatBox = [BubbleView new];
    self.chatBox.backgroundColor = [UIColor clearColor];
    self.chatBox.frame = CGRectMake(50, 50, bubbleSize.width, bubbleSize.height);
    
    [self.contentView addSubview:self.chatBox];
    [self.contentView addSubview:self.chatMessageContent];
}

- (void)updateConstraints {

    if (!self.isIncoming) {
        [self.chatBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.width.equalTo(@(self.chatBox.frame.size.width));
            make.height.equalTo(@(self.chatBox.frame.size.height));
        }];
        [self.chatMessageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.width.equalTo(@(self.chatBox.frame.size.width - 28));
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-22);
        }];
    } else {
        [self.chatBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.width.equalTo(@(self.chatBox.frame.size.width));
            make.height.equalTo(@(self.chatBox.frame.size.height));
        }];
        [self.chatMessageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(-14);
            make.width.equalTo(@(self.chatBox.frame.size.width - 28));
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-22);
        }];
    }
    
    [super updateConstraints];
}

- (void)prepareForReuse {
    [self.chatBox removeFromSuperview];
    [self.chatMessageContent removeFromSuperview];

    [super prepareForReuse];
}

@end
