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
@property (nonatomic, strong) UITextField *writeMessageTextField;

@end

@implementation CMMChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Chat";
    
    [self createBarButtonItem];
    [self setupUsernameTitleLabel];
    [self setupUserProfileImage];
    [self setupTopicLabel];
    [self setupChatTableView];
    [self setupMessagingTextField];
    
    [self updateConstraints];
}

- (void)setupMessagingTextField {
    self.writeMessageTextField = [UITextField new];
    self.writeMessageTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:self.writeMessageTextField];
}

- (void)setupChatTableView {
    self.chatTableView = [UITableView new];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatTableView.estimatedRowHeight = 100;
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    [self.view addSubview:self.chatTableView];
}

- (void)setupUsernameTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"Chatting with X";
    //self.titleLabel.text = [NSString stringWithFormat:@"Chatting with %@", self.conversation.users[1]];
    [self.titleLabel sizeToFit];
    
    [self.view addSubview:self.titleLabel];
}

- (void)setupTopicLabel {
    self.topicLabel = [UILabel new];
    self.topicLabel.text = @"Topic";
    //self.topicLabel.text = self.conversation.post.topic;
    [self.topicLabel sizeToFit];
    
    [self.view addSubview:self.topicLabel];
}

- (void)setupUserProfileImage {
    self.usersProfileImage = [UIImageView new];
    self.usersProfileImage.image = [UIImage imageNamed:@"DiscussionLogo"];
    self.usersProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.usersProfileImage];
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
        make.right.equalTo(self.view.mas_right).offset(10);
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
        make.bottom.equalTo(self.writeMessageTextField.mas_top).offset(-10);
    }];
    
    // Send Message Text Field
    [self.writeMessageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-8);
        make.left.equalTo(self.view).offset(8);
        make.height.equalTo(@(self.writeMessageTextField.intrinsicContentSize.height));
    }];
    
}

- (void)createBarButtonItem {
    UIBarButtonItem *viewProfileButton =[[UIBarButtonItem alloc] initWithTitle:@"View Profile" style:UIBarButtonItemStylePlain target:self action:@selector(viewProfile:)];

    self.navigationItem.rightBarButtonItem = viewProfileButton;
}

- (void)viewProfile:(id)sender{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"chatCell"];
    
    if (cell == nil) {
        cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.chatTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
