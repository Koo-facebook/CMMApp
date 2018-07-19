//
//  ConversationCell.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ConversationCell.h"

@implementation ConversationCell
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [self setupUsernameLabel];
            [self setupReadIndicator];
            [self setupTopicLabel];
            [self updateConstraints];
        }
        return self;
    }
    
- (void)setupUsernameLabel {
    self.usernameLabel = [UILabel new];
    for (CMMUser *user in self.conversation.users) {
        if (![user isEqual:PFUser.currentUser]) {
            
            //self.usernameLabel.text = user.username;
        }
    }
    self.usernameLabel.text = @"testing";
    self.usernameLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:173.0/255.0 blue:157.0/255.0 alpha:1.0];
    [self.usernameLabel sizeToFit];
    
    [self.contentView addSubview:self.usernameLabel];
}
    
- (void)setupReadIndicator {
    self.readIndicator = [UIImageView new];
    self.readIndicator.image = [UIImage imageNamed:@"DiscussionLogo"];
    self.readIndicator.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:self.readIndicator];
}
    
- (void)setupTopicLabel {
    self.topicLabel = [UILabel new];
    self.topicLabel.text = @"still testing";
    //self.topicLabel.text = self.conversation.post.topic;
    self.topicLabel.numberOfLines = 0;
    [self.topicLabel sizeToFit];
    
    [self.contentView addSubview:self.topicLabel];
}
    
- (void)updateConstraints {
    
    [super updateConstraints];
    
    // Read indicator
    [self.readIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readIndicator.superview.mas_top).offset(15);
        make.left.equalTo(self.readIndicator.superview.mas_left).offset(15);
        make.width.height.equalTo(@24);
    }];
    
    // Username label
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.readIndicator.mas_right).offset(10);
        make.top.equalTo(self.readIndicator.mas_top);
        make.right.equalTo(self.usernameLabel.superview.mas_right).offset(-10);
        make.height.equalTo(@(self.usernameLabel.intrinsicContentSize.height));
    }];
    
    // Topic label
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readIndicator.mas_bottom).offset(10);
        make.left.equalTo(self.readIndicator.mas_left);
        make.right.equalTo(self.usernameLabel.mas_right);
        make.bottom.equalTo(self.topicLabel.superview.mas_bottom).offset(-15);
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
