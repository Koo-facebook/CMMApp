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

@interface CMMModeratorPostVC ()

@end

@implementation CMMModeratorPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapReport {
}

- (void)createButtons {
    UILabel *moderatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 300, self.view.frame.size.width-24, 30)];
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
    
    /*
    [moderatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resourceButton.mas_bottom).with.offset(12);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
    }];*/
}

- (void)didPressYes {
    [[CMMParseQueryManager shared] deletePostFromParse:self.post];
    [[CMMParseQueryManager shared] addStrikeToUser:self.post.owner];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPressNo {
    [self.navigationController popViewControllerAnimated:YES];
    [self.post setObject:@(0) forKey:@"reportedNumber"];
    [self.post saveInBackground];
}

@end
