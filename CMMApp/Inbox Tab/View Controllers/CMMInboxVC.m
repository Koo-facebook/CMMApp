//
//  CMMInboxVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMInboxVC.h"
#import "CMMModeratorFeedVC.h"
#import "AppDelegate.h"
#import "CMMModerationController.h"

@interface CMMInboxVC ()

@property (strong, nonatomic) UISearchController *messagesSearchController;
@property (strong, nonatomic) NSTimer *timer;
    
@end

@implementation CMMInboxVC

#pragma mark - VC Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.hidesSearchBarWhenScrolling = YES;
    [self pullConversations];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(pullConversations) userInfo:nil repeats:true];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Inbox";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSearchController];
    [self createMessagesTableView];
    [self createTapGestureRecognizer:@selector(screenTapped:)];
    [self createRefreshControl];
    [self createBarButtonItem];
    [self updateConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - View Setup

- (void)createBarButtonItem {
    UIBarButtonItem *viewProfileButton =[[UIBarButtonItem alloc] initWithTitle:@"Moderate" style:UIBarButtonItemStylePlain target:self action:@selector(moderatorMode)];
    self.navigationItem.rightBarButtonItem = viewProfileButton;
}

- (void)createMessagesTableView {
    self.messagesTableView = [[UITableView alloc] init];
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    self.messagesTableView.rowHeight = UITableViewAutomaticDimension;
    self.messagesTableView.estimatedRowHeight = 100;
    
    [self.view addSubview:self.messagesTableView];
}

- (void)createSearchController {
    self.messagesSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.messagesSearchController.searchResultsUpdater = self;
    self.messagesSearchController.delegate = self;
    self.messagesSearchController.searchBar.delegate = self;
    
    self.messagesSearchController.hidesNavigationBarDuringPresentation = NO;
    self.messagesSearchController.dimsBackgroundDuringPresentation = YES;
    self.navigationItem.searchController = self.messagesSearchController;
    self.definesPresentationContext = YES;
    [self.navigationItem.searchController becomeFirstResponder];
}

- (void)createTapGestureRecognizer:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.cancelsTouchesInView = NO;
    [self.messagesTableView addGestureRecognizer:tapGesture];
}

- (void)createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullConversations) forControlEvents:UIControlEventValueChanged];
    [self.messagesTableView insertSubview:self.refreshControl atIndex:0];
}
    
- (void)updateConstraints {
    // Messages TableView
    [self.messagesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.left.right.equalTo(self.messagesTableView.superview);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Actions

- (void)screenTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    NSLog(@"hit this func");
}

- (void)moderatorMode {
    CMMModerationController *tabBar = [[CMMModerationController alloc] init];
    //[self.navigationController pushViewController:tabBar animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = tabBar;
}

#pragma mark - TableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMConversationCell *cell = [self.messagesTableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    
    if (cell == nil) {
        cell = [[CMMConversationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"conversationCell"];
    }
    
    cell.conversation = self.conversations[indexPath.row];
    [cell setupCell];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.messagesTableView deselectRowAtIndexPath:indexPath animated:NO];
    CMMChatVC *chatVC = [CMMChatVC new];
    chatVC.conversation = self.conversations[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *report = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Report Chat" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to report this chat?" message:@"Moderators will review the chat once it is reported" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:cancelAction];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CMMConversation *chat = self.conversations[indexPath.row];
            CMMUser *reportedUser;
            if ([chat.user1.objectId isEqualToString:CMMUser.currentUser.objectId]) {
                reportedUser = chat.user2;
            } else {
                reportedUser = chat.user1;
            }
            if (chat.reportedUsers) {
                [chat addObject:reportedUser forKey:@"reportedUsers"];
            } else {
                NSArray *reportedUsers = [[NSMutableArray alloc] init];
                [chat setObject:reportedUsers forKey:@"reportedUsers"];
            }
            
            [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Updated chat");
                }
            }];
        }];
        [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }];
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteConversation:indexPath];
    }];
    return [[NSArray alloc] initWithObjects:report, nil];
}

#pragma mark - Helpers

- (BOOL)isUserOneInConversation: (CMMConversation *)conversation {
    if ([CMMUser.currentUser.objectId isEqualToString:conversation.user1.objectId]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteConversation:(NSIndexPath *)indexPath {
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure you want to delete conversation? You will not be able to retrieve it later" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CMMConversationCell *cellToDelete = [self.messagesTableView cellForRowAtIndexPath:indexPath];
        CMMConversation *conversationToBeChanged = cellToDelete.conversation;
        if ([self isUserOneInConversation: conversationToBeChanged]) {
            conversationToBeChanged.user1 = nil;
        } else {
            conversationToBeChanged.user2 = nil;
        }
        if ((conversationToBeChanged.user1 == nil) && (conversationToBeChanged.user2 == nil)) {
            [self deleteMessageForConversation:conversationToBeChanged];
        } else {
            conversationToBeChanged.userWhoLeft = CMMUser.currentUser;
            [conversationToBeChanged saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                } else {
                    [self pullConversations];
                }
            }];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [deleteAlert addAction:yesAction];
    [deleteAlert addAction:cancelAction];
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

#pragma mark - API functions

- (void)deleteMessageForConversation: (CMMConversation *)conversation {
    [[CMMParseQueryManager shared] deleteMessageForConversation:conversation withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [conversation deleteInBackground];
        }
    }];
}

- (void)pullConversations {
    [[CMMParseQueryManager shared] fetchConversationsReported:NO WithCompletion:^(NSArray *conversations, NSError *error) {
        if (conversations.count > 0) {
            self.conversations = [NSMutableArray arrayWithArray:conversations];
            [self.messagesTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            [self createAlert:@"Error" message:@"Unable to retrieve conversations. Check Connection"];
        }
    }];
}

 @end
