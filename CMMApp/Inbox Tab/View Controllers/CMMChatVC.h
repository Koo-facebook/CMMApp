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
#import "ChatCell.h"
#import "CMMParseQueryManager.h"

@interface CMMChatVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate, UITextViewDelegate>

@property BOOL isUserOne;
@property (nonatomic, strong) CMMConversation *conversation;
@property (nonatomic, strong) NSMutableArray *messages;

@end
