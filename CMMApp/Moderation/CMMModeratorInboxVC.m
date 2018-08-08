//
//  CMMModeratorInboxVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMModeratorInboxVC.h"
#import "CMMParseQueryManager.h"
#import "CMMReportedChatVC.h"
#import "CMMMainTabBarVC.h"
#import "AppDelegate.h"

@interface CMMModeratorInboxVC ()

@end

@implementation CMMModeratorInboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Reported Chats";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)table editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMConversation *chat = self.conversations[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"Reports: %lu", chat.reportedUsers.count];
    UITableViewRowAction *reports = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    return [[NSArray alloc] initWithObjects:reports, nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMReportedChatVC *detailVC = [[CMMReportedChatVC alloc] init];
    CMMConversation *chat = self.conversations[indexPath.row];
    detailVC.conversation = chat;
    [[self navigationController] pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pullConversations {
    [[CMMParseQueryManager shared] fetchConversationsReported:YES WithCompletion:^(NSArray *conversations, NSError *error) {
        if (conversations.count) {
            self.conversations = [NSMutableArray arrayWithArray:conversations];
            [self.messagesTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            [self createAlert:@"Error" message:@"Unable to retrieve conversations. Check Connection"];
        }
    }];
}

- (void)createBarButtonItem {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"User Mode" style:UIBarButtonItemStylePlain target:self action:@selector(backToUserMode)];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)backToUserMode {
    CMMMainTabBarVC *tabBar = [[CMMMainTabBarVC alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = tabBar;
}


@end
