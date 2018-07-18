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

@interface CMMComposerVC ()
@property (strong, nonatomic) UITextView *questionTextField;
@property (strong, nonatomic) UITextField *descriptionTextField;
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
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Compose";
    int minimumSideBuffer = 15;
    int textCornerRadius = 5;
    CGRect questionFrame = CGRectMake(minimumSideBuffer, 100, self.view.frame.size.width - 2 * minimumSideBuffer, 30);
    CGRect descriptionFrame = CGRectMake(minimumSideBuffer, 200, self.view.frame.size.width - 2 * minimumSideBuffer, 100);
    self.questionTextField = [[UITextView alloc] initWithFrame:questionFrame];
    self.descriptionTextField = [[UITextField alloc] initWithFrame:descriptionFrame];
    self.questionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.questionTextField];
    [self.view addSubview:self.descriptionTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressPost:(id)sender {
    [CMMPost createPost:self.questionTextField.text description:self.descriptionTextField.text categories:nil tags:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successful post");
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController presentViewController:destinationVC animated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
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
