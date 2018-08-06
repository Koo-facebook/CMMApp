//
//  CMMReportedChatVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMReportedChatVC.h"
#import "CMMStyles.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

@interface CMMReportedChatVC () <CCDropDownMenuDelegate>
@property (strong, nonatomic) ManaDropDownMenu *menu;
@property (strong, nonatomic) ManaDropDownMenu *menu2;
@property (strong, nonatomic) NSArray *reportOptions;
@property (strong, nonatomic) NSMutableArray *strikeUsers;
@property (strong, nonatomic) UILabel *moderatorLabel;
@property (strong, nonatomic) NSArray *reportReasons;
@property (strong, nonatomic) NSString *reportReason;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIView *moderatorView;
@end

@implementation CMMReportedChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChat {
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(150);
    }];
}

- (void)createButtons {
    
    self.moderatorView = [[UIView alloc] init];
    self.moderatorView.backgroundColor = [CMMStyles getTealColor];
    [self.view addSubview:self.moderatorView];
    UITapGestureRecognizer *modTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu)];
    [self.moderatorView addGestureRecognizer:modTapRecognizer];
    
    self.moderatorLabel = [[UILabel alloc] init];
    self.moderatorLabel.text = @"Does this chat violate our community guidelines?";
    self.moderatorLabel.textColor = [UIColor whiteColor];
    self.moderatorLabel.numberOfLines = 0;
    [self.view addSubview:self.moderatorLabel];
    
    self.reportOptions = @[@"No", @"Yes, user1", @"Yes, user2", @"Yes, both users"];
    self.menu = [[ManaDropDownMenu alloc] init];
    self.menu.heightOfRows = 40;
    self.menu.delegate = self;
    self.menu.numberOfRows = self.reportOptions.count;
    self.menu.textOfRows = self.reportOptions;
    self.menu.title = @"No";
    [self.view addSubview:self.menu];
    
    UITapGestureRecognizer *viewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAwayFromMenu)];
    [self.chatTableView addGestureRecognizer:viewTapRecognizer];
    
    self.reportReasons = @[@"Hate Speech", @"Threats of Violence", @"Sexual Content", @"Spam"];
    self.menu2 = [[ManaDropDownMenu alloc] init];
    self.menu2.heightOfRows = 40;
    self.menu2.delegate = self;
    self.menu2.numberOfRows = self.reportReasons.count;
    self.menu2.textOfRows = self.reportReasons;
    self.menu2.title = @"Reason";
    [self.view addSubview:self.menu2];
    
    self.submitButton = [[UIButton alloc] init];
    [self.submitButton addTarget:self action:@selector(submitReport) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[UIColor grayColor]];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.submitButton];
    
    [self resetModBarWithHeight:100];
}

- (void)resetModBarWithHeight:(int)height {
    
    self.moderatorView.frame = CGRectMake(0, self.view.frame.size.height-height-50, self.view.frame.size.width, height + 50);
    
    self.menu.frame = CGRectMake(12, self.view.frame.size.height-height, self.view.frame.size.width/2 - 50, 40);
    
    self.moderatorLabel.frame = CGRectMake(12, self.view.frame.size.height-height-40, self.view.frame.size.width - 24, 30);
    
    self.menu2.frame = CGRectMake(self.view.frame.size.width/2 - 26, self.view.frame.size.height-height, self.view.frame.size.width/2 - 50, 40);
    
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(300);
    }];
    
    self.submitButton.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height-height, 60, 40);
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    if (dropDownMenu == self.menu) {
        NSString *reportee = self.reportOptions[index];
        self.strikeUsers = [[NSMutableArray alloc] init];
        if ([reportee isEqualToString:self.reportOptions[0]]) {
        } else if ([reportee isEqualToString:self.reportOptions[1]]) {
            [self.strikeUsers addObject:self.conversation.user1];
        } else if ([reportee isEqualToString:self.reportOptions[2]]) {
            [self.strikeUsers addObject:self.conversation.user2];
        } else if ([reportee isEqualToString:self.reportOptions[3]]) {
            [self.strikeUsers addObject:self.conversation.user1];
            [self.strikeUsers addObject:self.conversation.user2];
        }
    } else {
        self.reportReason = self.reportReasons[index];
    }
}

- (void)submitReport {
    for (CMMUser *user in self.strikeUsers) {
        [[CMMParseQueryManager shared] addStrikeToUser:user];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapMenu {
    [self resetModBarWithHeight:260];
}

- (void)didTapAwayFromMenu {
    [self resetModBarWithHeight:100];
}

- (void)setupSendMessageTextField {
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)setupMessagingTextView {
}

- (void)sendButtonPressed {
}

-(void)keyboardWillShow: (NSNotification *) notification {
}

-(void)keyboardWillHide: (NSNotification *) notification {
}

- (void)textViewDidChange:(UITextView *)textView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
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
