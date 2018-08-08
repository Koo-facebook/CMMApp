//
//  CMMModeratorPostVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 8/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMModeratorPostVC.h"
#import <Masonry.h>
#import "CMMStyles.h"
#import "CMMParseQueryManager.h"
#import <CCDropDownMenus.h>

@interface CMMModeratorPostVC () <CCDropDownMenuDelegate>
@property (strong, nonatomic) ManaDropDownMenu *menu;
@property (strong, nonatomic) ManaDropDownMenu *menu2;
@property (strong, nonatomic) NSArray *reportOptions;
@property (strong, nonatomic) NSMutableArray *strikeUsers;
@property (strong, nonatomic) UILabel *moderatorLabel;
@property (strong, nonatomic) NSArray *reportReasons;
@property (strong, nonatomic) NSString *reportReason;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIView *moderatorView;
@property (strong, nonatomic) UIView *upperView;
@end

@implementation CMMModeratorPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self configureDetails:self.post];
    //[self createButtons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapReport {
}

/*- (void)createButtons {
    UILabel *moderatorLabel = [[UILabel alloc] init];
    moderatorLabel.text = @"Does this chat violate our community guidelines?";
    moderatorLabel.numberOfLines = 0;
    [self.view addSubview:moderatorLabel];
    
    UIButton *yesButton = [[UIButton alloc] init];
    [yesButton addTarget:self action:@selector(didPressYes) forControlEvents:UIControlEventTouchUpInside];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton setBackgroundColor:[UIColor grayColor]];
    [yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:yesButton];
    [yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moderatorLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-(6 + self.view.frame.size.width/2));
    }];
    
    UIButton *noButton = [[UIButton alloc] init];
    [noButton addTarget:self action:@selector(didPressNo) forControlEvents:UIControlEventTouchUpInside];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton setBackgroundColor:[CMMStyles getTealColor]];
    [noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:noButton];
    [noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moderatorLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(6 + self.view.frame.size.width/2);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
    }];
    
    
    [moderatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(12);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
    }];
}

- (void)didPressYes {
    [[CMMParseQueryManager shared] deletePostFromParse:self.post];
    [[CMMParseQueryManager shared] addStrikeToUser:self.post.owner forReason:self.reportReason];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPressNo {
    [self.navigationController popViewControllerAnimated:YES];
    [self.post setObject:@(0) forKey:@"reportedNumber"];
    [self.post saveInBackground];
}*/

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
    
    self.reportOptions = @[@"Yes", @"No"];
    self.menu = [[ManaDropDownMenu alloc] init];
    self.menu.heightOfRows = 40;
    self.menu.delegate = self;
    self.menu.numberOfRows = self.reportOptions.count;
    self.menu.textOfRows = self.reportOptions;
    self.menu.title = @"Yes/No";
    [self.view addSubview:self.menu];
    
    self.upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 310)];
    [self.view addSubview:self.upperView];
    UITapGestureRecognizer *viewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAwayFromMenu)];
    [self.upperView addGestureRecognizer:viewTapRecognizer];
    
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
    
    self.submitButton.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height-height, 60, 40);
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    if (dropDownMenu == self.menu) {
        NSString *reportee = self.reportOptions[index];
        self.strikeUsers = [[NSMutableArray alloc] init];
        if ([reportee isEqualToString:self.reportOptions[0]]) {
            [self.strikeUsers addObject:self.post.owner];
        }
    } else {
        self.reportReason = self.reportReasons[index];
    }
}

- (void)submitReport {
    if (self.strikeUsers.count > 0) {
        [[CMMParseQueryManager shared] deletePostFromParse:self.post];
    }
    for (CMMUser *user in self.strikeUsers) {
        [[CMMParseQueryManager shared] addStrikeToUser:user forReason:self.reportReason];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapMenu {
    [self resetModBarWithHeight:260];
}

- (void)didTapAwayFromMenu {
    [self resetModBarWithHeight:100];
}

@end
