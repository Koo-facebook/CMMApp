//
//  CMMChatVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMChatVC.h"

@interface CMMChatVC ()

@property (nonatomic, strong) UIImageView *usersProfileImage;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UITextView *writeMessageTextView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MASConstraint *textViewBottomConstraint;
@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, assign) BOOL isMoreDataLoading;

@end

@implementation CMMChatVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isMoreDataLoading = YES;
    [self pullMessages];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(pullMessages) userInfo:nil repeats:true];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Chat";
    
    [self createBarButtonItem];
    [self setupUsernameTitleLabel];
    [self setupUserProfileImage];
    [self setupTopicLabel];
    [self setupChatTableView];
    [self setupMessagingTextView];
    
    [self updateConstraints];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - View Setup

- (void)setupMessagingTextView {

    self.writeMessageTextView = [UITextView new];
    self.writeMessageTextView.delegate = self;
    self.writeMessageTextView.font = [UIFont systemFontOfSize:18];
    self.writeMessageTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.writeMessageTextView.layer.borderWidth = 0.5;
    self.writeMessageTextView.layer.cornerRadius = self.writeMessageTextView.intrinsicContentSize.height/2;
    self.writeMessageTextView.clipsToBounds = YES;
    [self.writeMessageTextView setReturnKeyType:UIReturnKeySend];
    
    [self.view addSubview:self.writeMessageTextView];
}

- (void)setupChatTableView {
    self.chatTableView = [UITableView new];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatTableView.estimatedRowHeight = 150;
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTableView registerClass:[ChatCell class] forCellReuseIdentifier:@"chatCell"];
    self.chatTableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:self.chatTableView];
}

- (void)setupUsernameTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor purpleColor];
    if (self.isUserOne) {
        self.titleLabel.text = [NSString stringWithFormat:@"Chatting with %@", self.conversation.user2.username];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"Chatting with %@", self.conversation.user1.username];
    }
    [self.titleLabel sizeToFit];
    
    [self.view addSubview:self.titleLabel];
}

- (void)setupTopicLabel {
    self.topicLabel = [UILabel new];
    self.topicLabel.text = self.conversation.topic;
    [self.topicLabel sizeToFit];
    
    [self.view addSubview:self.topicLabel];
}

- (void)setupUserProfileImage {
    self.usersProfileImage = [UIImageView new];
    self.usersProfileImage.image = [UIImage imageNamed:@"DiscussionLogo"];
    self.usersProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.usersProfileImage];
}

- (void)createBarButtonItem {
    UIBarButtonItem *viewProfileButton =[[UIBarButtonItem alloc] initWithTitle:@"View Profile" style:UIBarButtonItemStylePlain target:self action:@selector(viewProfile:)];
    self.navigationItem.rightBarButtonItem = viewProfileButton;
}

- (void)creatRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.chatTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)updateConstraints {

    // Users Profile Image
    [self.usersProfileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.height.equalTo(@48);
    }];
    
    // Title Label
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usersProfileImage.mas_right).offset(10);
        make.centerY.equalTo(self.usersProfileImage.mas_centerY);
        make.width.equalTo(@(self.titleLabel.intrinsicContentSize.width));
    }];
    
    // Topic Label
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usersProfileImage.mas_bottom).offset(5);
        make.left.equalTo(self.usersProfileImage.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.height.equalTo(@(self.topicLabel.intrinsicContentSize.height));
    }];
    
    // Chats TableView
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.writeMessageTextView.mas_top).offset(-10);
    }];
    
    // Send Message Text Field
    [self.writeMessageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
        make.left.equalTo(self.view).offset(8);
        make.height.equalTo(@37.67);
    }];
    
}

#pragma mark - Actions

- (void)viewProfile:(id)sender{
    
}

- (void)sendButtonPressed {
    if (![self.writeMessageTextView.text isEqualToString:@""]) {
        [CMMMessage createMessage:self.conversation content:self.writeMessageTextView.text attachment:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self pullMessages];
            } else {
                [self createAlert:@"Error" message:@"Unable to send message. Please Check Connection"];
            }
        }];
        self.writeMessageTextView.text = @"";
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(self.keyboardSize.height+8));
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@36.67);
        }];
    }
}

- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

#pragma mark - Keyboard

-(void)keyboardWillShow: (NSNotification *) notification {
    self.keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat fixedWidth = self.writeMessageTextView.frame.size.width;
    CGSize newSize = [self.writeMessageTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    if (newSize.height < 36.67) {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(self.keyboardSize.height+8));
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@36.67);
        }];
    } else {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(self.keyboardSize.height+8));
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@(newSize.height));
        }];
    }
    
}

-(void)keyboardWillHide: (NSNotification *) notification {
    CGFloat fixedWidth = self.writeMessageTextView.frame.size.width;
    CGSize newSize = [self.writeMessageTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    if (newSize.height < 36.67) {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@36.67);
        }];
    } else {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@(newSize.height));
        }];
    }
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self sendButtonPressed];
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    if (newSize.height < 90) {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(self.keyboardSize.height+8));
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@(newSize.height));
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollToBottom:YES];
}

#pragma mark - ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        if (scrollView.contentOffset.y == 0) {
            self.isMoreDataLoading = YES;
            [self.refreshControl beginRefreshing];
            [self pullMoreMessages];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.writeMessageTextView resignFirstResponder];
}

- (void)scrollToBottom: (BOOL)animation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)scrollToSelectedRow: (NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - TableView Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"chatCell"];
    
    if (cell == nil) {
        cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
    }
    
    cell.message = self.messages[indexPath.row];
    [cell showMessage];
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.chatTableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - API interaction

- (void)pullMessages {
    [[CMMParseQueryManager shared] fetchConversationMessagesWithCompletion:self.conversation skipCount:0 withCompletion:^(NSArray *messages, NSError *error) {
        if (messages) {
            CMMMessage *firstMessage = messages[0];
            CMMMessage *mostRecentMessageShown = self.messages[self.messages.count - 1];
            if (![firstMessage.objectId isEqualToString: mostRecentMessageShown.objectId]) {
                self.messages = [NSMutableArray new];
                for (CMMMessage *message in messages) {
                    [self.messages insertObject:message atIndex:0];
                }
                [self.chatTableView reloadData];
                [self scrollToBottom: NO];
                self.isMoreDataLoading = NO;
            }
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
            [self createAlert:@"Error" message:@"Unable load messages. Please Check Connection"];
        }
    }];
}

- (void)pullMoreMessages {
    [[CMMParseQueryManager shared] fetchConversationMessagesWithCompletion:self.conversation skipCount:self.messages.count withCompletion:^(NSArray *messages, NSError *error) {
        if ((messages) && (messages.count > 0)) {
            for (CMMMessage *message in messages) {
                [self.messages insertObject:message atIndex:0];
            }
            self.isMoreDataLoading = false;
            [self.chatTableView reloadData];
            [self.refreshControl endRefreshing];
            [self scrollToSelectedRow:messages.count];
        } else if (messages.count == 0) {
            self.isMoreDataLoading = YES;
        } else if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}
@end
