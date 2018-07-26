//
//  LoginVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMLoginVC.h"

@interface CMMLoginVC ()
    
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *logoImage;
    
@end

@implementation CMMLoginVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLoginGradient];
    
    // Create objects
    [self createSignUpButton];
    [self createLoginButton];
    [self createUsernameTextField];
    [self createPasswordTextField];
    [self createTitleLabel];
    [self createLogoImageView];
    
    // Update Constraints
    [self updateConstraints];
    [self createTapGestureRecognizer:@selector(wholeViewTapped)];
}
    
- (void)updateConstraints {
    
    // Title Label
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImage.mas_bottom).offset(40);
        make.centerX.equalTo(self.titleLabel.superview.mas_centerX);
        make.height.equalTo(@(self.titleLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.titleLabel.intrinsicContentSize.width));
    }];
    
    // Username TextField
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.usernameTextField.superview.mas_centerX);
        make.width.equalTo(@275);
        make.height.equalTo(@(self.usernameTextField.intrinsicContentSize.height));
    }];
    
    // Password TextField
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self.passwordTextField.superview.mas_centerX);
        make.width.equalTo(@275);
        make.height.equalTo(@(self.passwordTextField.intrinsicContentSize.height));
    }];
    
    // Signup Button
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(60);
        make.left.equalTo(self.passwordTextField.mas_left);
        make.width.equalTo(@(self.signUpButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.signUpButton.intrinsicContentSize.height));
    }];
    
    // Login Button
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signUpButton.mas_top);
        make.right.equalTo(self.passwordTextField.mas_right);
        make.height.equalTo(@(self.loginButton.intrinsicContentSize.height));
        make.width.equalTo(@(self.loginButton.intrinsicContentSize.width));
    }];
    
    // Logo Image
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.equalTo(@64);
    }];
}
    
    // Register user action
- (void)signUpButtonTapped {
    [self registerUser];
}
    
    // Login user action
- (void)loginButtonTapped {
    [self loginUser];
}
    
    // Make keyboard disappear action
- (void)wholeViewTapped {
    [self.view endEditing:YES];
}
    
    // Initialize Title Label
- (void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Change My Mind";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:38];
    [self.view addSubview:self.titleLabel];
}
    
    // Initalize Password TextField
- (void)createPasswordTextField {
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"Password...";
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.passwordTextField];
}
    
    // Initalize Username TextField
- (void)createUsernameTextField {
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.placeholder = @"Username...";
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.usernameTextField];
}
    
    // Initialize Login Button
- (void)createLoginButton {
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}
    
    // Initialize Signup Button
- (void)createSignUpButton {
    self.signUpButton = [[UIButton alloc] init];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.signUpButton addTarget:self action:@selector(signUpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
}
    
    // Initalize Logo
-(void)createLogoImageView {
    self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiscussionLogo"]];
    self.logoImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.logoImage];
}
    
    // Initalize Gradient
- (void)createLoginGradient {
    // Do any additional setup after loading the view, typically from a nib.
    UIColor *color1 = [UIColor colorWithRed:75.0/255.0 green:228.0/255.0 blue:180.0/255.0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:35.0/255.0 green:110.0/255.0 blue:174.0/255.0 alpha:1.0];
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)color1.CGColor, (id)color2.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    theViewGradient.startPoint = CGPointMake(0, 0);
    theViewGradient.endPoint = CGPointMake(1, 1);
    
    //Add gradient to view
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}
    
    // Creates Generic TapGestureRecognizer
- (void)createTapGestureRecognizer:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [self.view addGestureRecognizer:tapGesture];
}
    
// Create alert with given message and title
- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
    
    // Login user into parse server
- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [self createAlert:@"Error" message:@"Either username or password is empty"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CMMUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self createAlert:@"Login Error" message:error.localizedDescription];
            } else {
                NSLog(@"User logged in successfully");
                if (CMMUser.currentUser.online == YES) {
                    //[self createAlert:@"Error" message:@"User already logged in"];
                    CMMMainTabBarVC *tabBarVC = [[CMMMainTabBarVC alloc] init];
                    [self presentViewController:tabBarVC animated:YES completion:^{}];
                } else {
                    CMMUser.currentUser.online = YES;
                    CMMMainTabBarVC *tabBarVC = [[CMMMainTabBarVC alloc] init];
                    [self presentViewController:tabBarVC animated:YES completion:^{}];
                }
            }
            
        }];
    }
}
    
    // Register new user in parse server
- (void)registerUser {
    
    if ([self.usernameTextField.text isEqualToString: @""] || [self.passwordTextField.text isEqualToString: @""]) {
        [self createAlert:@"Error" message:@"Either username or password is empty"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CMMUser createUser:self.usernameTextField.text password:self.passwordTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error, CMMUser *newUser) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self createAlert:@"Sign Up Error" message:@"There was a problem signing up. Please try again"];
            } else {
                NSLog(@"User registered successfully");
                CMMMainTabBarVC *tabBarVC = [[CMMMainTabBarVC alloc] init];
                [self presentViewController:tabBarVC animated:YES completion:^{}];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
@end
