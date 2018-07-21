//
//  ChatCell.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)setupChatCell {
    [self setupChatMessage];
    [self updateConstraints];
}

- (void)setupChatMessage {
    self.chatMessageContent.text = @"testing again";
    //self.chatMessageContent.text = self.message.content;
    [self.chatMessageContent sizeToFit];
    
    [self.contentView addSubview:self.chatMessageContent];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.chatMessageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(4);
        make.right.bottom.equalTo(self.contentView).offset(-4);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
