//
//  ConversationCell.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMConversationCell.h"

@implementation CMMConversationCell
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return self;
    }

- (void)setupCell {
    [self setupUsernameLabel];
    [self setupProfileImage];
    [self setupTopicLabel];
    [self setupOnlineIndicator];
    [self updateConstraints];
}
    
- (void)setupUsernameLabel {
    self.usernameLabel = [UILabel new];
    [self setUsernameText];
    [self adjustTextForReadIndicator:self.usernameLabel];
    [self.usernameLabel sizeToFit];
    
    [self.contentView addSubview:self.usernameLabel];
}
    
- (void)setupProfileImage {
    self.profileImage = [PFImageView new];
    [self chooseProfileImage];
    [self.profileImage loadInBackground];
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.layer.cornerRadius = 24;
    self.profileImage.clipsToBounds = YES;
    
    [self.contentView addSubview:self.profileImage];
}
    
- (void)setupTopicLabel {
    self.topicLabel = [UILabel new];
    self.topicLabel.text = self.conversation.topic;
    self.topicLabel.numberOfLines = 0;
    [self adjustTextForReadIndicator:self.topicLabel];
    [self.topicLabel sizeToFit];
    
    [self.contentView addSubview:self.topicLabel];
}

- (void)setupOnlineIndicator {
    self.onlineIndicator = [UIImageView new];
    [self setRespectiveOnlineImage];
    self.onlineIndicator.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.onlineIndicator];
}

- (void)setRespectiveOnlineImage {
    if ([self checkIfUserOne]) {
        if ([self userStillInConversation:self.conversation.user2]) {
            if (self.conversation.user2.online) {
                self.onlineIndicator.image = [UIImage imageNamed:@"onlineIndicator"];
            } else {
                self.onlineIndicator.image = [UIImage imageNamed:@"offlineIndicator"];
            }
        } else {
            self.onlineIndicator.image = nil;
            [self.onlineIndicator sizeToFit];
        }
    } else {
        if ([self userStillInConversation:self.conversation.user1]) {
            if (self.conversation.user1.online) {
                self.onlineIndicator.image = [UIImage imageNamed:@"onlineIndicator"];
            } else {
                self.onlineIndicator.image = [UIImage imageNamed:@"offlineIndicator"];
            }
        } else {
            self.onlineIndicator = nil;
            [self.onlineIndicator sizeToFit];
        }
    }
}

- (void)chooseProfileImage {
    if ([self checkIfUserOne]) {
        if ([self userStillInConversation:self.conversation.user2]) {
            self.profileImage.file = self.conversation.user2.profileImage;
        } else {
            self.profileImage.file = self.conversation.userWhoLeft.profileImage;
        }
    } else {
        if ([self userStillInConversation:self.conversation.user1]) {
            self.profileImage.file = self.conversation.user1.profileImage;
        } else {
            self.profileImage.file = self.conversation.userWhoLeft.profileImage;
        }
    }
}

- (void)setUsernameText {
    if ([self checkIfUserOne]) {
        if ([self userStillInConversation:self.conversation.user2]) {
            self.usernameLabel.text = self.conversation.user2.username;
            self.usernameLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:173.0/255.0 blue:157.0/255.0 alpha:1.0];
        } else {
            self.usernameLabel.text = [NSString stringWithFormat:@"%@ has left the conversation", self.conversation.userWhoLeft.username];
            self.usernameLabel.textColor = [UIColor redColor];
        }
    } else {
        if ([self userStillInConversation:self.conversation.user1]) {
            self.usernameLabel.text = self.conversation.user1.username;
            self.usernameLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:173.0/255.0 blue:157.0/255.0 alpha:1.0];
        } else {
            self.usernameLabel.text = [NSString stringWithFormat:@"%@ has left the conversation", self.conversation.userWhoLeft.username];
            self.usernameLabel.textColor = [UIColor redColor];
        }
    }
}

- (BOOL)userStillInConversation: (CMMUser *) user {
    if (user == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void)adjustTextForReadIndicator: (UILabel *)label {
    if (![self returnIfCurrentUserRead]) {
        label.font = [UIFont boldSystemFontOfSize:15];
    } else {
        label.font = [CMMStyles getTextFontWithSize:15 ];
    }
}

- (BOOL)checkIfUserOne {
    if ([CMMUser.currentUser.objectId isEqualToString:self.conversation.user1.objectId]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)returnIfCurrentUserRead {
    if ([self checkIfUserOne]) {
        if (self.conversation.userOneRead) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (self.conversation.userTwoRead) {
            return YES;
        } else {
            return NO;
        }
    }
}
    
- (void)updateConstraints {
    
    // Read indicator
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.superview.mas_top).offset(15);
        make.left.equalTo(self.profileImage.superview.mas_left).offset(15);
        make.width.height.equalTo(@48);
    }];
    
    // Username label
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profileImage.mas_right).offset(10);
        make.top.equalTo(self.profileImage.mas_top);
        make.right.equalTo(self.usernameLabel.superview.mas_right).offset(-10);
        make.height.equalTo(@(self.usernameLabel.intrinsicContentSize.height));
    }];
    
    // Topic label
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.usernameLabel.mas_left);
        make.right.equalTo(self.usernameLabel.mas_right);
        make.bottom.equalTo(self.topicLabel.superview.mas_bottom).offset(-15);
    }];
    
    // Online Indicator
    [self.onlineIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.profileImage.mas_right);
        make.bottom.equalTo(self.profileImage.mas_bottom);
        make.height.width.equalTo(@12);
    }];
    
    [super updateConstraints];
}

- (void)prepareForReuse {
    [self.usernameLabel removeFromSuperview];
    [self.topicLabel removeFromSuperview];
    [self.onlineIndicator removeFromSuperview];

    [super prepareForReuse];
}
    
@end
