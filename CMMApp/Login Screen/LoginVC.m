//
//  LoginVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "LoginVC.h"


@interface LoginVC ()
    
@property UIButton *signUpButton;
@property UIButton *loginButton;
@property UITextField *usernameTextField;
@property UITextField *passwordTextField;
@property UILabel *titleLabel;

@end

@implementation LoginVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create objects
    [self createSignUpButton];
    [self createLoginButton];
    [self createUsernameTextField];
    [self createPasswordTextField];
    [self createTitleLabel];
    
    // Update Constraints
    [self updateConstraints];
    [self createTapGestureRecognizer];
}

- (void)updateConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.superview.mas_top).offset(120);
        make.centerX.equalTo(self.titleLabel.superview.mas_centerX);
        make.height.equalTo(@(self.titleLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.titleLabel.intrinsicContentSize.width));
    }];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.usernameTextField.superview.mas_centerX);
        make.width.equalTo(@275);
        make.height.equalTo(@(self.usernameTextField.intrinsicContentSize.height));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self.passwordTextField.superview.mas_centerX);
        make.width.equalTo(@275);
        make.height.equalTo(@(self.passwordTextField.intrinsicContentSize.height));
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(60);
        make.left.equalTo(self.passwordTextField.mas_left);
        make.width.equalTo(@(self.signUpButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.signUpButton.intrinsicContentSize.height));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signUpButton.mas_top);
        make.right.equalTo(self.passwordTextField.mas_right);
        make.height.equalTo(@(self.loginButton.intrinsicContentSize.height));
        make.width.equalTo(@(self.loginButton.intrinsicContentSize.width));
    }];
}
    
- (void)signUpButtonTapped {
    [self registerUser];
}
    
- (void)loginButtonTapped {
    [self loginUser];
}
    
- (void)wholeViewTapped {
    [self.view endEditing:YES];
}
    
- (void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Change My Mind";
    self.titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:107.0/255.0 blue:101.0/255.0 alpha:0.6];
    self.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:38];
    [self.view addSubview:self.titleLabel];
}
    
- (void)createPasswordTextField {
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"Password...";
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.passwordTextField];
}
    
- (void)createUsernameTextField {
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.placeholder = @"Username...";
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.usernameTextField];
}
    
- (void)createLoginButton {
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:107.0/255.0 blue:101.0/255.0 alpha:0.6] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}
    
- (void)createSignUpButton {
    self.signUpButton = [[UIButton alloc] init];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:107.0/255.0 blue:101.0/255.0 alpha:0.6] forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.signUpButton addTarget:self action:@selector(signUpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
}
    
- (void)createTapGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wholeViewTapped)];
    [self.view addGestureRecognizer:tapGesture];
}
    
    - (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
    
- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [self createAlert:@"Error" message:@"Either username or password is empty"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self createAlert:@"Login Error" message:@"There was a problem logging in. Please try again."];
            } else {
                NSLog(@"User logged in successfully");
                [self presentViewController:[[CMMMainTabBarVC alloc] init] animated:YES completion:^{}];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)registerUser {
    
    if ([self.usernameTextField.text isEqualToString: @""] || [self.passwordTextField.text isEqualToString: @""]) {
        [self createAlert:@"Error" message:@"Either username or password is empty"];
    }
    else {
        CMMUser *newUser = [CMMUser createUser:self.usernameTextField.text password:self.passwordTextField.text];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self createAlert:@"Sign Up Error" message:@"There was a problem signing up. Please try again"];
            } else {
                NSLog(@"User registered successfully");
            }
        }];
    }
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
