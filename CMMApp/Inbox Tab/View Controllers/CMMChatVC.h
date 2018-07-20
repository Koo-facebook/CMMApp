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

@interface CMMChatVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property BOOL isUserOne;
@property (nonatomic, strong) CMMConversation *conversation;

@end
