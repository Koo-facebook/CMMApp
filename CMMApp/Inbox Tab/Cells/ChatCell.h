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
#import "BubbleView.h"

@interface ChatCell : UITableViewCell

@property (nonatomic, strong) CMMMessage *message;
@property (nonatomic, strong) UILabel *chatMessageContent;
@property (nonatomic, strong) BubbleView *chatBox;

- (void)showMessage;

@end
