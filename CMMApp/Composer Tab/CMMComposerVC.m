//
//  CMMComposerVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMComposerVC.h"
#import "CMMNewsfeedVC.h"
#import "CMMPost.h"
#import <CCDropDownMenus/CCDropDownMenus.h>
#import "CMMStyles.h"

@interface CMMComposerVC () <CCDropDownMenuDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *questionTextField;
@property (strong, nonatomic) UITextField *descriptionTextField;
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSArray *categoryOptions;
@end

@implementation CMMComposerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(didPressPost:)];
    self.navigationItem.rightBarButtonItem = postButton;
}

- (void)configureViews {
    
    self.title = @"Compose";
    [self createBackgroundGradient];
    self.categoryOptions = [CMMStyles getCategories];
    
    // scroll view
    CGRect scrollFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 50*(self.categoryOptions.count + 2) + 200);
    [self.view addSubview:self.scrollView];
    
    // create typing fields
    int minimumSideBuffer = 15;
    int textCornerRadius = 5;
    CGRect questionFrame = CGRectMake(minimumSideBuffer, 20, self.view.frame.size.width - 2 * minimumSideBuffer, 40);
    CGRect descriptionFrame = CGRectMake(minimumSideBuffer, 70, self.view.frame.size.width - 2 * minimumSideBuffer, 100);
    self.questionTextField = [[UITextField alloc] initWithFrame:questionFrame];
    self.descriptionTextField = [[UITextField alloc] initWithFrame:descriptionFrame];
    self.questionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextField.layer.cornerRadius = textCornerRadius;
    self.questionTextField.backgroundColor = [UIColor whiteColor];
    self.descriptionTextField.backgroundColor = [UIColor whiteColor];
    self.questionTextField.placeholder = @"What's your stance?";
    self.descriptionTextField.placeholder = @"Tell us why!";
    [self.scrollView addSubview:self.questionTextField];
    [self.scrollView addSubview:self.descriptionTextField];
    
    // tap gesture recognizer
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(minimumSideBuffer + 150, 170, self.view.frame.size.width - 150 - minimumSideBuffer, self.scrollView.frame.size.height - 170)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addSubview:tapView];
    [tapView addGestureRecognizer:tapRecognizer];

    // create dropdown menu for category
    CGRect menuFrame = CGRectMake(minimumSideBuffer, 200, 150, 50);
    ManaDropDownMenu *menu = [[ManaDropDownMenu alloc] initWithFrame:menuFrame title:@"Category"];
    menu.heightOfRows = 50;
    menu.delegate = self;
    menu.numberOfRows = self.categoryOptions.count;
    menu.textOfRows = self.categoryOptions;
    [self.scrollView addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}


- (IBAction)didPressPost:(id)sender {
    [CMMPost createPost:self.questionTextField.text description:self.descriptionTextField.text category:self.categoryString tags:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error, CMMPost *post) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"successful post");
            [CMMUser.currentUser saveInBackground];
            self.questionTextField.text = @"";
            self.descriptionTextField.text = @"";
            self.tabBarController.selectedIndex = 0;
        }
    }];
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    self.categoryString = self.categoryOptions[index];
}

- (void)createBackgroundGradient {
    UIColor *color1 = [UIColor colorWithRed:75.0/255.0 green:228.0/255.0 blue:180.0/255.0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:35.0/255.0 green:110.0/255.0 blue:174.0/255.0 alpha:1.0];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)color1.CGColor, (id)color2.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    theViewGradient.startPoint = CGPointMake(0, 0);
    theViewGradient.endPoint = CGPointMake(1, 1);
    
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

@end
