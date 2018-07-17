//
//  CMMLoginVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMLoginVC : UIViewController
    
    @property (weak, nonatomic) IBOutlet UIButton *signupButton;
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
    @property (weak, nonatomic) IBOutlet UITextField *usernameText;
    @property (weak, nonatomic) IBOutlet UITextField *passwordText;
    @property (strong, nonatomic) IBOutlet UIView *overallView;
    
    @end

