//
//  CMMEditProfileVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMEditProfileVC.h"
#import "Masonry.h"

@interface CMMEditProfileVC ()

@end

@implementation CMMEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLabel];
    [self updateConstraints];
}

- (void)updateConstraints {
    //Label
    [self.helloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.helloLabel.superview.mas_top).offset(250);
        make.centerX.equalTo(self.helloLabel.superview.mas_centerX);
        //make.height.equalTo(@(self.helloLabel.intrinsicContentSize.height));
        make.width.equalTo(@(300));
    }];
}

-(void) createLabel{
    self.helloLabel = [[UILabel alloc] init];
    self.helloLabel.textColor = [UIColor blackColor];
    self.helloLabel.font = [UIFont fontWithName:@"Arial" size:26];
    self.helloLabel.numberOfLines = 0;
    self.helloLabel.text = @"You are now in the Edit Profile View Controller";
    [self.view addSubview:self.helloLabel];
}
@end
