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
#import <CoreML/CoreML.h>
#import "MessageClassifier.h"

@interface CMMComposerVC () <CCDropDownMenuDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *questionTextField;
@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) ManaDropDownMenu *menu;
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSArray *categoryOptions;
@property (strong, nonatomic) UILabel *placeholderLabel;
@end

@implementation CMMComposerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    self.descriptionTextView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (CMMUser.currentUser.strikes.intValue >= 3) {
        [self showAlert:@"Your account is temporarily suspended from posting on the feed" Message:@"" Sender:self];
    } else {
        UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(didPressPost:)];
        self.navigationItem.rightBarButtonItem = postButton;
    }
}

- (void)configureViews {
    //Navigation Bar
    self.navigationItem.title = @"Compose";
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)(9.0/255.0) green:(CGFloat)(99.0/255.0) blue:(CGFloat)(117.0/255.0) alpha:1];
    //[self createBackgroundGradient];
    self.categoryOptions = [CMMStyles getCategories];
    
    // scroll view
    CGRect scrollFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 50*(self.categoryOptions.count + 3) + 200);
    [self.view addSubview:self.scrollView];
    
    // create typing fields
    int minimumSideBuffer = 15;
    int textCornerRadius = 5;
    CGRect questionFrame = CGRectMake(minimumSideBuffer, 20, self.view.frame.size.width - 2 * minimumSideBuffer, 40);
    CGRect descriptionFrame = CGRectMake(minimumSideBuffer, 70, self.view.frame.size.width - 2 * minimumSideBuffer, 200);
    self.questionTextField = [[UITextField alloc] initWithFrame:questionFrame];
    self.descriptionTextView = [[UITextView alloc] initWithFrame:descriptionFrame];
    self.questionTextField.font = [UIFont fontWithName:@"Montserrat-Regular.ttf" size:14.0];
    self.questionTextField.layer.cornerRadius = textCornerRadius;
    self.descriptionTextView.layer.cornerRadius = textCornerRadius;
    self.questionTextField.backgroundColor = [UIColor whiteColor];
    self.descriptionTextView.backgroundColor = [UIColor whiteColor];
    self.questionTextField.placeholder = @"  What's your stance?";
    [self.scrollView addSubview:self.questionTextField];
    [self.scrollView addSubview:self.descriptionTextView];
    
    // text view placeholder text
    CGRect placeholderFrame = CGRectMake(minimumSideBuffer, 70, self.view.frame.size.width - 2 * minimumSideBuffer, 40);
    self.placeholderLabel = [[UILabel alloc] initWithFrame:placeholderFrame];
    self.placeholderLabel.text = @"  Tell us why!";
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.font = [UIFont fontWithName:@"Montserrat-Regular.ttf" size:14.0];
    [self.scrollView addSubview:self.placeholderLabel];
    
    // tap gesture recognizer
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(minimumSideBuffer + 150, 170, self.view.frame.size.width - 150 - minimumSideBuffer, self.scrollView.frame.size.height - 170)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addSubview:tapView];
    [tapView addGestureRecognizer:tapRecognizer];

    // create dropdown menu for category

    CGRect menuFrame = CGRectMake(minimumSideBuffer, 280, 150, 50);
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

- (void)showAlert:(NSString *)title Message:(NSString *)message Sender:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [sender presentViewController:alert animated:YES completion:^{
    }];
}

- (IBAction)didPressPost:(id)sender {
    if ([self.questionTextField.text isEqualToString:@""]) {
        [self showAlert:@"Oops!" Message:@"Don't forget to type your post" Sender:self];
        return;
    } else if (!self.categoryString) {
        [self showAlert:@"Oops!" Message:@"Don't forget to categorize your post" Sender:self];
        return;
    } else if (([self isSpam:self.questionTextField.text]) || ([self isSpam:self.descriptionTextView.text])) {
        if ([CMMUser currentUser].spamWarnings == nil) {
            [CMMUser currentUser].spamWarnings = [NSNumber numberWithInt:1];
        } else {
            [CMMUser currentUser].spamWarnings = [NSNumber numberWithInt:[[CMMUser currentUser].spamWarnings integerValue] + 1];
        }
        [[CMMUser currentUser] saveInBackground];
        [self showAlert:@"Warning" Message:[NSString stringWithFormat:@"Your message was classified as spam. You now have %@ warnings", [CMMUser currentUser].spamWarnings] Sender:self];
        self.questionTextField.text = @"";
        self.descriptionTextView.text = @"";
    } else {
        [CMMPost createPost:self.questionTextField.text description:self.descriptionTextView.text category:self.categoryString tags:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error, CMMPost *post) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"successful post");
                [CMMUser.currentUser saveInBackground];
                self.questionTextField.text = @"";
                self.descriptionTextView.text = @"";
                self.tabBarController.selectedIndex = 0;
            }
        }];
    }
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    self.categoryString = self.categoryOptions[index];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.descriptionTextView.text isEqualToString:@""]) {
        [self.placeholderLabel setHidden:NO];
    } else {
        [self.placeholderLabel setHidden:YES];
    }
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

-(BOOL)isSpam:(NSString *)checkText {
    NSString *text = checkText;
    NSString *wordsFile = @"";
    wordsFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"words_ordered" ofType:@"txt"];
    NSString *smsFile = [[NSBundle mainBundle] pathForResource:@"SMSSpamCollection" ofType:@"txt"];
    NSString *wordsFileText = [NSString stringWithContentsOfFile:wordsFile encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *wordsData = [NSMutableArray arrayWithArray:[wordsFileText componentsSeparatedByString:@"\n"]];
    [wordsData removeLastObject];
    NSString *smsFileText = [NSString stringWithContentsOfFile:smsFile encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *smsData = [NSMutableArray arrayWithArray:[smsFileText componentsSeparatedByString:@"\n"]];
    [smsData removeLastObject];
    NSMutableArray *wordsInMessage = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@" "]];
    
    MLMultiArray *vectorized = [[MLMultiArray alloc] initWithShape:[NSArray arrayWithObject:[NSNumber numberWithUnsignedInteger:wordsData.count]] dataType:MLMultiArrayDataTypeDouble error:nil];
    
    for (int i = 0; i < wordsData.count; i++) {
        NSString *word = wordsData[i];
        if ([text containsString:word]) {
            int wordCount = 0;
            for (NSString *substr in wordsInMessage) {
                if ([self elementsEqual:substr secondString:word]) {
                    wordCount += 1;
                }
            }
            double tf = (double)wordCount / (double)wordsInMessage.count;
            int docCount = 0;
            for (NSString *sms in smsData) {
                if ([sms containsString:word]) {
                    docCount += 1;
                }
            }
            double idf = log((double)smsData.count / (double)docCount);
            vectorized[i] = [NSNumber numberWithDouble:tf * idf];
        } else {
            vectorized[i] = [NSNumber numberWithDouble:0.0];
        }
    }
    
    MessageClassifier *model = [MessageClassifier new];
    MessageClassifierOutput *output = [model predictionFromMessage:vectorized error:nil];
    if ([output.label isEqualToString:@"spam"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)elementsEqual:(NSString *)firstString secondString: (NSString *)secondString {
    NSArray *firstArray = [firstString componentsSeparatedByString:@""];
    NSArray *secondArray = [secondString componentsSeparatedByString:@""];
    if (secondArray.count > firstArray.count) {
        return NO;
    }
    for (int i = 0; i < secondArray.count; i++) {
        if (![secondArray[i] isEqualToString:firstArray[i]]) {
            return NO;
        }
    }
    return YES;
}

@end
