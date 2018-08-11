//
//  LoginVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMLoginVC.h"
#import "CMMRegisterVC.h"
#import <CMMKit/FullScrollView.h>
#import <Lottie/Lottie.h>


@interface CMMLoginVC ()
    
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subheading;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) FullScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *screenScrollView;
@property (nonatomic, assign) CGSize keyboardSize;
//@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *animate;

@property (nonatomic, strong) UIView *animationContainer;
@property (nonatomic, strong) LOTAnimationView *lottieAnimation;

    
@end

@implementation CMMLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self.lottieAnimation play];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    //[self createBackgroundImage];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)(9.0/255.0) green:(CGFloat)(99.0/255.0) blue:(CGFloat)(117.0/255.0) alpha:1];
    
    // Create objects
    [self createScreenScrollView];
    [self createScrollView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self createTapGestureRecognizer:@selector(wholeViewTapped)];
}
    
- (void)updateConstraints {

    // Whole Screen ScrollView
    [self.screenScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // Title Label
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.superview.mas_top).offset(95);
        make.centerX.equalTo(self.titleLabel.superview.mas_centerX);
        make.height.equalTo(@(self.titleLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.titleLabel.intrinsicContentSize.width));
    }];

    //Subheading Label
    [self.subheading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.subheading.superview.mas_centerX);
        make.width.equalTo(@(self.subheading.intrinsicContentSize.width));
        make.height.equalTo(@(self.subheading.intrinsicContentSize.height));
    }];

    // Animation Container
    [self.animationContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subheading.mas_bottom).offset(25);
        make.centerX.equalTo(self.animationContainer.superview.mas_centerX);
        make.width.equalTo(@(self.animationContainer.superview.frame.size.width/1.85));
        make.height.equalTo(self.animationContainer.mas_width);
    }];

    // Username TextField
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(25);
        make.centerX.equalTo(self.usernameTextField.superview.mas_centerX);
        make.width.equalTo(@275);
        make.height.equalTo(@(self.usernameTextField.intrinsicContentSize.height));
    }];

    // Password TextField
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(25);
        make.centerX.equalTo(self.passwordTextField.superview.mas_centerX);
        make.width.equalTo(@275);
        make.height.equalTo(@(self.passwordTextField.intrinsicContentSize.height));
    }];

    // Signup Button
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30);
        make.left.equalTo(self.passwordTextField.mas_left).offset(25);
        make.width.equalTo(@(self.signUpButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.signUpButton.intrinsicContentSize.height));
    }];

    // Login Button
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signUpButton.mas_top);
        make.right.equalTo(self.passwordTextField.mas_right).offset(-25);
        make.height.equalTo(@(self.loginButton.intrinsicContentSize.height));
        make.width.equalTo(@(self.loginButton.intrinsicContentSize.width));
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

-(void)keyboardWillAppear: (NSNotification *)notification {
    NSLog(@"keyboardWillAppear");
    [self keyboardResize:notification];
}

- (void)keyboardWillHide: (NSNotification *)notification {
    NSLog(@"keyboard will disappear");
    [self keyboardResize:notification];
}

-(void)keyboardResize: (NSNotification *)notification {
    self.screenScrollView.scrollEnabled = YES;
    NSDictionary *userInfo = notification.userInfo;
    CGRect keybaordEndFrame = [((NSValue *)[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]) CGRectValue];

    if (keybaordEndFrame.origin.y == self.view.frame.size.height) {
        [self.screenScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.screenScrollView setContentOffset:CGPointMake(0, self.view.frame.size.height - keybaordEndFrame.origin.y-80.) animated:YES];
    }
}

- (void)createScreenScrollView {
    self.screenScrollView = [UIScrollView new];
    self.screenScrollView.scrollEnabled = NO;
    [self.view addSubview:self.screenScrollView];
}

    // Initialize Title Label
- (void)createTitleLabelInView: (UIView *)view {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Change My Mind";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:38];
    [view addSubview:self.titleLabel];
}

    // Initialize Subheading Label
-(void)createSubheadingLabelInView: (UIView *)view withSubheading:(NSString *)subheading {
    self.subheading = [[UILabel alloc]init];
    self.subheading.frame = CGRectMake((self.view.frame.size.width/5.35),( self.view.frame.size.height/10), 250, 100);
    self.subheading.textAlignment = NSTextAlignmentCenter;
    self.subheading.textColor = [UIColor whiteColor];
    self.subheading.font = [UIFont fontWithName:@"Arial" size:16];
    self.subheading.numberOfLines = 0;
    self.subheading.text = subheading;
    [view addSubview:self.subheading];
}

    //Initialize Animation Container
-(void)createAnimationContainerInView: (UIView *)view withIndex: (NSInteger)index {
    self.animate = @[@"circleFlag",@"search",@"newsfeed_refresh5",@"phoneVote",@"resources"];
    self.animationContainer = [[UIView alloc]init];
    
    NSString *file = self.animate[index];
    self.lottieAnimation = [LOTAnimationView animationNamed:file];
    
    self.lottieAnimation.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.lottieAnimation.loopAnimation = YES;
    
    self.lottieAnimation.contentMode = UIViewContentModeScaleAspectFit;
    CGRect lottieRect = CGRectMake(0, 0, (self.animationContainer.bounds.size.width), (self.animationContainer.bounds.size.height));
    self.lottieAnimation.frame = lottieRect;
    
    [self.animationContainer addSubview:self.lottieAnimation];
    [self.lottieAnimation play];
    [view addSubview:self.animationContainer];
}
    
    // Initalize Password TextField
- (void)createPasswordTextField {
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"Password...";
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.screenScrollView addSubview:self.passwordTextField];
}
    
    // Initalize Username TextField
- (void)createUsernameTextField {
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.placeholder = @"Username...";
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.screenScrollView addSubview:self.usernameTextField];
}
    
    // Initialize Login Button
- (void)createLoginButton {
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.screenScrollView addSubview:self.loginButton];
}
    
    // Initialize Signup Button
- (void)createSignUpButton {
    self.signUpButton = [[UIButton alloc] init];
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.signUpButton addTarget:self action:@selector(signUpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.screenScrollView addSubview:self.signUpButton];
}

-(void)createScrollView {
    
    NSArray *titles = @[@"Welcome to Change My Mind", @"Register to Vote", @"Have educational dialogue", @"Learn more about the hot topic political issues", @"Become more involved politically"];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/1.45);
    self.scrollView = [[FullScrollView alloc]initWithFrame:frame andNumberOfPages:5];
    [self.screenScrollView addSubview:self.scrollView];
    
    self.scrollView.pagingEnabled = YES;
    
    [self.scrollView configureViewAtIndexWithCompletion:^(UIView *view, NSInteger index, BOOL success) {
        
        [self createSignUpButton];
        [self createLoginButton];
        [self createUsernameTextField];
        [self createPasswordTextField];
        [self createTitleLabelInView:view];
        [self createAnimationContainerInView:view withIndex:index];
        
        NSString *subhead = titles[index];
        NSLog(@"%@", subhead);
        [self createSubheadingLabelInView:view withSubheading:titles[index]];

        // Update Constraints
        [self updateConstraints];
        
    }];
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
                PFACL *userACL = [PFACL ACLWithUser:CMMUser.currentUser];
                [userACL setPublicReadAccess:YES];
                [userACL setPublicWriteAccess:YES];
                CMMUser.currentUser.ACL = userACL;
                //[[CMMParseQueryManager shared] setUserStrikes:CMMUser.currentUser sender:self];
                [CMMUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    NSLog(@"finished");
                }];
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
    
    // Register by seguing to RegisterVC
- (void)registerUser {
    
    if ([self.usernameTextField.text isEqualToString: @""] || [self.passwordTextField.text isEqualToString: @""]) {
        [self createAlert:@"Error" message:@"Either username or password is empty"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CMMUser createUser:self.usernameTextField.text password:self.passwordTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self createAlert:@"Sign Up Error" message:@"There was a problem signing up. Please try again"];
            } else {
            
                NSLog(@"User registered successfully");
                [CMMUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * user, NSError *  error) {
                    //                NSLog(@"User logged in successfully");
                    PFACL *userACL = [PFACL ACLWithUser:CMMUser.currentUser];
                    [userACL setPublicReadAccess:YES];
                    [userACL setPublicWriteAccess:YES];
                    CMMUser.currentUser.ACL = userACL;
                    [CMMUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        NSLog(@"finished");
                    }];
                    if (CMMUser.currentUser.online == YES) {
                        //[self createAlert:@"Error" message:@"User already logged in"];
                        CMMRegisterVC *registerVC = [[CMMRegisterVC alloc] init];
                        [self presentViewController:registerVC animated:YES completion:^{}];
                    } else {
                        CMMUser.currentUser.online = YES;
                        CMMRegisterVC *registerVC = [[CMMRegisterVC alloc] init];
                        [self presentViewController:registerVC animated:YES completion:^{}];
                    }
                }];
            }
        }];
    }
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
@end
