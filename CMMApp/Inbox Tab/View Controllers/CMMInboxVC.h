//
//  CMMInboxVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "CMMConversationCell.h"
#import "CMMChatVC.h"
#import "CMMParseQueryManager.h"
#import "CMMLanguageProcessor.h"

@interface CMMInboxVC : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate>
- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage;
@property (strong, nonatomic) UITableView *messagesTableView;
@property (strong, nonatomic) NSMutableArray *conversations;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end
