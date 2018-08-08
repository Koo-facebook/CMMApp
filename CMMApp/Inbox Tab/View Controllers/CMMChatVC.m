//
//  CMMChatVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMChatVC.h"

@interface CMMChatVC ()

@property (nonatomic, strong) PFImageView *usersProfileImage;
@property (nonatomic, strong) UIImageView *onlineIndicator;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UILabel *reportLabel;
@property (nonatomic, assign) BOOL isMoreDataLoading;
@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, strong) UITextView *writeMessageTextView;
@end

@implementation CMMChatVC

#pragma mark - VC Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self pullMessages];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(pullMessages) userInfo:nil repeats:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isMoreDataLoading = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Chat";
    
    [self createBarButtonItem];
    [self setupUsernameTitleLabel];
    [self setupUserProfileImage];
    [self setupTopicLabel];
    [self setupReportLabel];
    [self setupChatTableView];
    [self setupOnlineIndicator];
    [self setupMessagingTextView];
    [self checkPermissions];
    [self updateConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - View Setup

- (void)setupMessagingTextView {
    if (![self otherUserLeft]) {
        self.writeMessageTextView = [UITextView new];
        self.writeMessageTextView.delegate = self;
        self.writeMessageTextView.font = [UIFont systemFontOfSize:18];
        self.writeMessageTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.writeMessageTextView.layer.borderWidth = 0.5;
        self.writeMessageTextView.layer.cornerRadius = 18;
        self.writeMessageTextView.clipsToBounds = YES;
        [self.writeMessageTextView setReturnKeyType:UIReturnKeySend];
        self.writeMessageTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        
        [self.view addSubview:self.writeMessageTextView];
    }
}

- (void)setupChatTableView {
    self.chatTableView = [UITableView new];
    self.chatTableView.layer.borderWidth = 0.5;
    self.chatTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatTableView.estimatedRowHeight = 150;
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTableView registerClass:[CMMChatCell class] forCellReuseIdentifier:@"chatCell"];
    self.chatTableView.translatesAutoresizingMaskIntoConstraints = false;
    self.chatTableView.allowsSelection = NO;
    
    [self.view addSubview:self.chatTableView];
}

- (void)setupUsernameTitleLabel {
    self.titleLabel = [UILabel new];
    [self setUsernameLabelText];
    [self.titleLabel sizeToFit];
    
    [self.view addSubview:self.titleLabel];
}

- (void)setupTopicLabel {
    self.topicLabel = [UILabel new];
    
    NSString *text = [@"Topic: " stringByAppendingString:self.conversation.topic];
    [self boldFirstSixLetters: text];
    [self.topicLabel sizeToFit];
    
    [self.view addSubview:self.topicLabel];
}

- (void)setupReportLabel {
    self.reportLabel = [[UILabel alloc] init];
    self.reportLabel.text = @"...";
    
    self.reportLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *reportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapReport)];
    [self.reportLabel addGestureRecognizer:reportTap];
    [self.view addSubview:self.reportLabel];
}

- (void)didTapReport {
    CMMUser *otherUser;
    if (self.isUserOne) {
        otherUser = self.conversation.user2;
    } else {
        otherUser = self.conversation.user1;
    }
    for (CMMUser *user in self.conversation.reportedUsers) {
        if ([user.objectId isEqualToString:otherUser.objectId]) {
            return;
        }
    }
    if (self.conversation.reportedUsers) {
        [self.conversation addObject:otherUser forKey:@"reportedUsers"];
    } else {
        NSArray *reportedUsers = [[NSMutableArray alloc] init];
        [self.conversation setObject:reportedUsers forKey:@"reportedUsers"];
    }
    [self.conversation saveInBackground];
}

- (void)setupUserProfileImage {
    self.usersProfileImage = [PFImageView new];
    [self setOtherUsersProfileImage];
    [self.usersProfileImage loadInBackground];
    self.usersProfileImage.layer.cornerRadius = 24;
    self.usersProfileImage.clipsToBounds = YES;
    self.usersProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.usersProfileImage];
}

- (void)setupOnlineIndicator {
    self.onlineIndicator = [UIImageView new];
    [self setRespectiveOnlineImage];
    [self.view addSubview:self.onlineIndicator];
}

- (void)createBarButtonItem {
    UIBarButtonItem *viewProfileButton =[[UIBarButtonItem alloc] initWithTitle:@"View Profile" style:UIBarButtonItemStylePlain target:self action:@selector(viewProfile:)];
    self.navigationItem.rightBarButtonItem = viewProfileButton;
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
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    // Topic Label
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usersProfileImage.mas_bottom).offset(5);
        make.left.equalTo(self.usersProfileImage.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.height.equalTo(@(self.topicLabel.intrinsicContentSize.height));
    }];
    
    // Chats TableView
    [self setupChat];
    
    // Send Message Text Field
    [self setupSendMessageTextField];
    
    // Online Indicator
    [self.onlineIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.usersProfileImage.mas_right);
        make.bottom.equalTo(self.usersProfileImage.mas_bottom);
        make.width.height.equalTo(@12);
    }];
    
    // Report Label
    [self.reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.usersProfileImage.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-12);
    }];
    
}

- (void)setupChat {
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        if ([self otherUserLeft]) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.writeMessageTextView.mas_top).offset(-10);
        }
    }];
}

- (void)setupSendMessageTextField {
    if (![self otherUserLeft]) {
        [self.writeMessageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@41.67);
        }];
    }
}

#pragma mark - Actions

- (void)checkPermissions {
    CMMUser *otherUser;
    if (self.isUserOne) {
        otherUser = self.conversation.user2;
    } else {
        otherUser = self.conversation.user1;
    }
    NSString *blockingKey = [otherUser.objectId stringByAppendingString:@"-blockedUsers"];
    NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
    for (NSString *userID in blockedUsers) {
        if ([userID isEqualToString:CMMUser.currentUser.objectId]) {
            [self createAlert:@"This user has blocked you" message:@"You can no longer send messages in this chat"];
            self.writeMessageTextView.editable = NO;
            break;
        }
    }
    if (CMMUser.currentUser.strikes.intValue >= 3) {
        [self createAlert:@"Your account is temporarily suspended" message:@"You can no longer send messages in this chat"];
        self.writeMessageTextView.editable = NO;
    }
}

- (void)viewProfile:(id)sender{
    CMMProfileVC *profileVC = [CMMProfileVC new];
    if ([self checkIfUserOne]) {
        profileVC.user = self.conversation.user2;
    } else {
        profileVC.user = self.conversation.user1;
    }
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)sendButtonPressed {
    if (![self.writeMessageTextView.text isEqualToString:@""]) {
        [CMMMessage createMessage:self.conversation content:self.writeMessageTextView.text attachment:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error, CMMMessage *message) {
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
            make.height.equalTo(@41.67);
        }];
    }
}

#pragma mark - Helpers

- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)setRespectiveOnlineImage {
    if ([self checkIfUserOne]) {
        if ([self userStillInConversation:self.conversation.user2]) {
            if (self.conversation.user2.online) {
                self.onlineIndicator.image = [UIImage imageNamed:@"onlineIndicator"];
            } else {
                self.onlineIndicator.image = [UIImage imageNamed:@"offlineIndicator"];
            }
        } else {
            self.onlineIndicator.image = nil;
            [self.onlineIndicator sizeToFit];
        }
    } else {
        if ([self userStillInConversation:self.conversation.user1]) {
            if (self.conversation.user1.online) {
                self.onlineIndicator.image = [UIImage imageNamed:@"onlineIndicator"];
            } else {
                self.onlineIndicator.image = [UIImage imageNamed:@"offlineIndicator"];
            }
        } else {
            self.onlineIndicator = nil;
            [self.onlineIndicator sizeToFit];
        }
    }
}

- (void)markConversationAsRead {
    if ([self.conversation.user1.objectId isEqualToString:CMMUser.currentUser.objectId]) {
        self.conversation.userOneRead = YES;
    } else {
        self.conversation.userTwoRead = YES;
    }
    [self.conversation saveInBackground];
}

- (BOOL)checkIfUserOne {
    if ([CMMUser.currentUser.objectId isEqualToString:self.conversation.user1.objectId]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)otherUserLeft {
    if ([self checkIfUserOne]) {
        if (self.conversation.user2 == nil) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (self.conversation.user1 == nil) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)userStillInConversation: (CMMUser *) user {
    if (user == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gotNewMessages: (NSArray *)messages {
    if (messages.count == 0) {
        return NO;
    } else if (self.messages == nil) {
        return YES;
    } else {
        CMMMessage *messageFromQuery = messages.firstObject;
        CMMMessage *messageFromSelf = self.messages.lastObject;
        NSLog(@"%@", messageFromQuery.content);
        NSLog(@"%@", messageFromSelf.content);
        if ([messageFromSelf.objectId isEqualToString:messageFromQuery.objectId]) {
            return NO;
        } else {
            return YES;
        }
    }
}
    
- (void)boldFirstSixLetters: (NSString *)text {
    if ([self.topicLabel respondsToSelector:@selector(setAttributedText:)]) {
        // Create the attributes
        const CGFloat fontSize = 18;
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                NSForegroundColorAttributeName:[UIColor blackColor]
                                };
        NSDictionary *subAttrs = @{
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]
                                   };
        
        const NSRange range = NSMakeRange(0,6);
        
        // Create the attributed string (text + attributes)
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attrs];
        [attributedText setAttributes:subAttrs range:range];
        
        // Set it in our UILabel and we are done!
        [self.topicLabel setAttributedText:attributedText];
    }
}

- (void)setUsernameLabelText {
    if ([self checkIfUserOne]) {
        if ([self userStillInConversation:self.conversation.user2]) {
            self.titleLabel.text = [NSString stringWithFormat:@"Chatting with %@", self.conversation.user2.username];
        } else {
            self.titleLabel.text = [NSString stringWithFormat: @"%@ has left the conversation", self.conversation.userWhoLeft.username];
            self.titleLabel.textColor = [UIColor redColor];
        }
    } else {
        if ([self userStillInConversation:self.conversation.user1]) {
            self.titleLabel.text = [NSString stringWithFormat:@"Chatting with %@", self.conversation.user1.username];
        } else {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ has left the conversation", self.conversation.userWhoLeft.username];
            self.titleLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)setOtherUsersProfileImage {
    if ([self checkIfUserOne]) {
        if ([self userStillInConversation:self.conversation.user2]) {
            self.usersProfileImage.file = self.conversation.user2.profileImage;
        } else {
            self.usersProfileImage.file = self.conversation.userWhoLeft.profileImage;
        }
    } else {
        if ([self userStillInConversation:self.conversation.user1]) {
            self.usersProfileImage.file = self.conversation.user1.profileImage;
        } else {
            self.usersProfileImage.file = self.conversation.userWhoLeft.profileImage;
        }
    }
}

#pragma mark - Keyboard

-(void)keyboardWillShow: (NSNotification *) notification {
    self.keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat fixedWidth = self.writeMessageTextView.frame.size.width;
    CGSize newSize = [self.writeMessageTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    if (newSize.height < 41.67) {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(self.keyboardSize.height+8));
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@41.67);
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

-(void)keyboardDidShow: (NSNotification *) notification {
    [self scrollToBottom:YES];
}

-(void)keyboardWillHide: (NSNotification *) notification {
    CGFloat fixedWidth = self.writeMessageTextView.frame.size.width;
    CGSize newSize = [self.writeMessageTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    if (newSize.height < 41.67) {
        [self.writeMessageTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
            make.left.equalTo(self.view).offset(8);
            make.height.equalTo(@41.67);
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
    if (self.messages.count > 0) {
        //[self scrollToBottom:YES];
    }
}

#pragma mark - ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        if (scrollView.contentOffset.y == 0) {
            self.isMoreDataLoading = YES;
            [self pullMoreMessages];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.writeMessageTextView resignFirstResponder];
}

- (void)scrollToBottom: (BOOL)animation {
    if (self.messages != nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)scrollToSelectedRow: (NSUInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - TableView Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CMMChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"chatCell"];
    
    if (cell == nil) {
        cell = [[CMMChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
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

- (void)updateOtherUserStatus {
    if ([self checkIfUserOne]) {
        [self.conversation.user2 fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [self setRespectiveOnlineImage];
            }
        }];
    } else {
        [self.conversation.user1 fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [self setRespectiveOnlineImage];
            }
        }];
    }
}

- (void)pullMessages {
    [self updateOtherUserStatus];
    [self.conversation fetchInBackground];
    [[CMMParseQueryManager shared] fetchConversationMessagesWithCompletion:self.conversation skipCount:0 withCompletion:^(NSArray *messages, NSError *error) {
        if (messages) {
            if ([self gotNewMessages:messages]) {
                self.messages = [NSMutableArray new];
                for (CMMMessage *message in messages) {
                    [self.messages insertObject:message atIndex:0];
                }
                [self.chatTableView reloadData];
                [self scrollToBottom: NO];
                self.isMoreDataLoading = NO;
                [self markConversationAsRead];
            }
        } else if (error) {
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
            self.isMoreDataLoading = NO;
            [self.chatTableView reloadData];
            [self scrollToSelectedRow:messages.count];
        } else if (messages.count == 0) {
            self.isMoreDataLoading = YES;
        } else if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}
@end
