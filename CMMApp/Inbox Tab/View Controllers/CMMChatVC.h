//
//  CMMChatVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMConversation.h"
#import "CMMMessage.h"
#import "CMMChatCell.h"
#import "CMMParseQueryManager.h"
#import <ParseUI/ParseUI.h>
#import "CMMProfileVC.h"
#import <Foundation/Foundation.h>
#import "MessageClassifier.h"

@interface CMMChatVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UILabel *topicLabel;
@property BOOL isUserOne;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CMMConversation *conversation;
- (void)pullMessages;

@end
