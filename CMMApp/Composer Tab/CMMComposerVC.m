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
    
    // create typing fields
    int minimumSideBuffer = 15;
    int textCornerRadius = 5;
    CGRect questionFrame = CGRectMake(minimumSideBuffer, 100, self.view.frame.size.width - 2 * minimumSideBuffer, 40);
    CGRect descriptionFrame = CGRectMake(minimumSideBuffer, 150, self.view.frame.size.width - 2 * minimumSideBuffer, 100);
    self.questionTextField = [[UITextField alloc] initWithFrame:questionFrame];
    self.descriptionTextField = [[UITextField alloc] initWithFrame:descriptionFrame];
    self.questionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextField.layer.cornerRadius = textCornerRadius;
    self.questionTextField.backgroundColor = [UIColor whiteColor];
    self.descriptionTextField.backgroundColor = [UIColor whiteColor];
    self.questionTextField.placeholder = @"What's your stance?";
    self.descriptionTextField.placeholder = @"Tell us why!";
    [self.view addSubview:self.questionTextField];
    [self.view addSubview:self.descriptionTextField];
    
    // create dropdown menu for category
    CGRect menuFrame = CGRectMake(minimumSideBuffer, 270, 150, 50);
    ManaDropDownMenu *menu = [[ManaDropDownMenu alloc] initWithFrame:menuFrame title:@"Category"];
    menu.delegate = self;
    menu.numberOfRows = 3;
    self.categoryOptions = [CMMStyles getCategories];
    menu.textOfRows = self.categoryOptions;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressPost:(id)sender {
    [CMMPost createPost:self.questionTextField.text description:self.descriptionTextField.text category:self.categoryString tags:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        // Two things to work on here: it always shows an error even though it works. This may be the same error Omar is working on now. Once we fix that, I want to make it switch to the newsfeed tab when someone posts (not segue within the compose tab)
        if (error) {
            NSLog(@"CUSTOM Error: %@", error.localizedDescription);
        } else {
            NSLog(@"successful post");
            [CMMUser.currentUser saveInBackground];
            self.questionTextField.text = @"";
            self.descriptionTextField.text = @"";
            //CMMNewsfeedVC *feedVC = [[CMMNewsfeedVC alloc] init];
            self.tabBarController.selectedIndex = 0;
            //[[self navigationController] pushViewController:feedVC animated:YES];
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

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
