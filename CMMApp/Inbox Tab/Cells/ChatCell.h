//
//  ChatCell.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMMessage.h"
#import "Masonry.h"

@interface ChatCell : UITableViewCell

@property (nonatomic, strong) CMMMessage *message;
@property (nonatomic, strong) UILabel *chatMessageContent;

- (void)setupChatCell;

@end
