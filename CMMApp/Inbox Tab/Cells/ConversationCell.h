//
//  ConversationCell.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "CMMConversation.h"

@interface ConversationCell : UITableViewCell

@property (nonatomic, assign) BOOL isUserOne;
@property (nonatomic, strong) UIImageView *readIndicator;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) CMMConversation *conversation;

- (void)setupCell;
    
@end
