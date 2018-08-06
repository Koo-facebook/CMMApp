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
        make.bottom.equalTo(self.view.mas_bottom).offset(350);
    }];
}

- (void)createButtons {
    UILabel *moderatorLabel = [[UILabel alloc] init];
    moderatorLabel.text = @"Does this chat violate our community guidelines?";
    moderatorLabel.numberOfLines = 0;
    [self.view addSubview:moderatorLabel];
    [moderatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-300);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
    }];
    
    NSArray *reportOptions = @[@"No", @"Yes, user1", @"Yes, user2", @"Yes, both users"];
    CGRect menuFrame = CGRectMake(12, self.view.frame.size.height - 250, self.view.frame.size.width/2 - 18, 40);
    self.menu = [[ManaDropDownMenu alloc] initWithFrame:menuFrame title:@"Category"];
    self.menu.heightOfRows = 40;
    self.menu.delegate = self;
    self.menu.numberOfRows = reportOptions.count;
    self.menu.textOfRows = reportOptions;
    [self.view addSubview:self.menu];
    
    
    

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
