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

@interface CMMComposerVC () <CCDropDownMenuDelegate>
@property (strong, nonatomic) UITextView *questionTextField;
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
    
    // set background gradient
    CGRect backgroundFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIImage *backgroundImage = [[UIImage alloc] init];
    backgroundImage = [UIImage imageNamed:@"backgroundPic"];
    UIImageView *pictureView = [[UIImageView alloc] initWithFrame:backgroundFrame];
    [pictureView setImage:backgroundImage];
    [self.view addSubview:pictureView];
    
    // create typing fields
    int minimumSideBuffer = 15;
    int textCornerRadius = 5;
    CGRect questionFrame = CGRectMake(minimumSideBuffer, 100, self.view.frame.size.width - 2 * minimumSideBuffer, 40);
    CGRect descriptionFrame = CGRectMake(minimumSideBuffer, 150, self.view.frame.size.width - 2 * minimumSideBuffer, 100);
    self.questionTextField = [[UITextView alloc] initWithFrame:questionFrame];
    self.descriptionTextField = [[UITextField alloc] initWithFrame:descriptionFrame];
    self.questionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.questionTextField];
    [self.view addSubview:self.descriptionTextField];
    
    // create dropdown menu for category
    CGRect menuFrame = CGRectMake(minimumSideBuffer, 270, 150, 50);
    ManaDropDownMenu *menu = [[ManaDropDownMenu alloc] initWithFrame:menuFrame title:@"Category"];
    menu.delegate = self;
    menu.numberOfRows = 3;
    self.categoryOptions = @[@"Economics", @"Immigration", @"Healthcare"];
    menu.textOfRows = self.categoryOptions;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressPost:(id)sender {
    [CMMPost createPost:self.questionTextField.text description:self.descriptionTextField.text category:self.categoryString tags:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successful post");
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController presentViewController:destinationVC animated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    self.categoryString = self.categoryOptions[index];
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
