//
//  CMMInboxVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMInboxVC.h"

@interface CMMInboxVC ()
    
@property UISearchBar *messagesSearchBar;
@property UITableView *messagesTableView;
@property NSMutableArray *conversations;
    
@end

@implementation CMMInboxVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pullConversations];
    
    self.title = @"Inbox";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSearchBar];
    [self createMessagesTableView];
    [self createTapGestureRecognizer:@selector(screenTapped:)];
    
    [self updateConstraints];
}
    
- (void)createMessagesTableView {
    self.messagesTableView = [[UITableView alloc] init];
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    
    self.messagesTableView.rowHeight = UITableViewAutomaticDimension;
    self.messagesTableView.estimatedRowHeight = 100;
    
    [self.view addSubview:self.messagesTableView];
}
    
- (void)createSearchBar {
    self.messagesSearchBar = [[UISearchBar alloc] init];
    self.messagesSearchBar.delegate = self;
    
    self.messagesSearchBar.layer.cornerRadius = 20;
    self.messagesSearchBar.clipsToBounds = YES;
    self.messagesSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self.view addSubview:self.messagesSearchBar];
}

- (void)createTapGestureRecognizer:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.cancelsTouchesInView = NO;
    [self.messagesTableView addGestureRecognizer:tapGesture];
}
    
- (void)updateConstraints {
    
    // Search Bar
    [self.messagesSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messagesSearchBar.superview.mas_safeAreaLayoutGuideTop);
        make.trailing.equalTo(self.view.mas_trailing);
        make.leading.equalTo(self.view.mas_leading);
        make.height.equalTo(@(self.messagesSearchBar.intrinsicContentSize.height));
    }];
    
    // Messages TableView
    [self.messagesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messagesSearchBar.mas_bottom);
        make.bottom.left.right.equalTo(self.messagesTableView.superview);
    }];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = [self.messagesTableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    
    if (cell == nil) {
        cell = [[ConversationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"conversationCell"];
        cell.conversation = self.conversations[indexPath.row];
        [cell setupCell];
    }
    
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.conversations.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.messagesTableView deselectRowAtIndexPath:indexPath animated:NO];
    ConversationCell *tappedCell = [self.messagesTableView cellForRowAtIndexPath:indexPath];
    CMMChatVC *chatVC = [CMMChatVC new];
    chatVC.isUserOne = tappedCell.isUserOne;
    chatVC.conversation = self.conversations[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)screenTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)pullConversations {
    [[CMMParseQueryManager shared] fetchConversationsWithCompletion:^(NSArray *conversations, NSError *error) {
        if (conversations) {
            self.conversations = [NSMutableArray arrayWithArray:conversations];
            [self.messagesTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
    
@end
