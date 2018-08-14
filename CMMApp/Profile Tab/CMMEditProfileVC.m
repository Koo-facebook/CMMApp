//
//  CMMEditProfileVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//


#import "CMMEditProfileVC.h"
#import "CMMNewsfeedVC.h"
#import "InterestsCell.h"
#import "CMMMainTabBarVC.h"
#import "CMMUser.h"
#import "Masonry.h"
#import "Parse.h"
#import "ParseUI.h"
#import "MBProgressHUD.h"
#import <Lottie/Lottie.h>

@interface CMMEditProfileVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *tableOneCategories;
@property (strong, nonatomic) NSArray *tableTwoCategories;
@property (strong, nonatomic) NSMutableArray *interests;
@property (strong, nonatomic) UILabel *interestsLabel;
@property (strong, nonatomic) NSArray *chosenInterests;
@property (strong, nonatomic) LOTAnimationView *lottieAnimation;
@property (strong, nonatomic) UIView *animationContainer;
@property (strong, nonatomic) UIScrollView *screenScrollView;
@property (strong, nonatomic) UILabel *placeholderLabel;


@end

@implementation CMMEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViewOne registerClass:[InterestsCell class] forCellReuseIdentifier:@"interestsCell"];
    [self.tableViewTwo registerClass:[InterestsCell class] forCellReuseIdentifier:@"interestsCell"];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableOneCategories = @[@"Social Issues",@"Education",@"Criminal Issues",@"Economics",@"Elections",@"Environment"];
    self.tableTwoCategories = @[@"Foreign Policy",@"Healthcare",@"Immigration",@"Local Politics",@"National Security",@"Global"];
    self.interests = [[NSMutableArray alloc]init];
    self.chosenInterests = [[NSArray alloc]init];
    
    //[self createLabel];
    //[self createScrollView];
    [self createCancelButton];
    [self createSubmitButton];
    [self createBioTextView];
    [self createNameTextField];
    [self createVotingLabel];
    [self createVoterSwitch];
    [self createProfileImageContainer];
    [self createInterestLabel];
    [self createTableViewOne];
    [self createtableViewTwo];
    [self updateConstraints];
    
    
    //[self.tableViewOne reloadData];
    [self createTapGestureRecognizer:@selector(photoTapped) with:self.profileImage];
    [self createTapGestureRecognizer:@selector(wholeViewTapped) with:self.view];
}

- (void)updateConstraints {
//    //Cancel Button
//    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.cancelButton.superview.mas_top).offset(30);
//        make.width.equalTo(@(75));
//        make.height.equalTo(@(40));
//        make.left.equalTo(self.cancelButton.superview.mas_left).offset(25);
//    }];
//    //Submit Button
//    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.cancelButton.mas_top);
//        make.width.equalTo(@(75));
//        make.height.equalTo(@(40));
//        make.right.equalTo(self.cancelButton.superview.mas_right).offset(-25);
//    }];
    
    //Profile Image Container
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.superview.mas_top).offset(85);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.equalTo(@(200));
        make.width.equalTo(@(200));
    }];
    
    //Voting Label
    [self.votingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.mas_top).offset(70);
        make.left.equalTo(self.profileImage.mas_right).offset(15);
        make.width.equalTo(@(125));
    }];
    
    //Voting Switch
    [self.voterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.votingLabel.mas_bottom).offset(10);
        make.left.equalTo(self.votingLabel.mas_left);
        make.width.equalTo(self.votingLabel.mas_width);
        make.height.equalTo(@(40));
    }];
    
    //Name TextField
    [self.displayedName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(30));
        make.width.equalTo(@(325));
    }];
    //Bio TextField
    [self.profileBio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayedName.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(75));
        make.width.equalTo(@(325));
    }];
    
    //Interest Label
    [self.interestsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileBio.mas_bottom).offset(10);
        make.width.equalTo(self.profileBio.mas_width);
        make.left.equalTo(self.profileBio.mas_left);
    }];
    
    //TableViewOne
    [self.tableViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.interestsLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
        // make.centerX.equalTo(self.view.mas_centerX);
        //make.height.equalTo(@(self.tableViewOne.intrinsicContentSize.height));
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.equalTo(@(self.view.frame.size.width/2.3));
    }];
    
    //TableViewTwo
    [self.tableViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.interestsLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-25);
        //make.centerX.equalTo(self.view.mas_centerX);
        //make.height.equalTo(@(self.tableViewOne.intrinsicContentSize.height));
        make.left.equalTo(self.tableViewOne.mas_right);
        make.width.equalTo(@(self.view.frame.size.width/2.3));
    }];
    
}

#pragma mark - Elements

-(void)createCancelButton {
    self.cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(exitRegisterVC)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
}

-(void)createSubmitButton {
    self.submitButton = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(finishedEditing)];
    self.navigationItem.rightBarButtonItem = self.submitButton;
}

-(void)createProfileImageContainer {
    self.profileImage = [[UIImageView alloc]init];
    self.profileImage.backgroundColor = [UIColor blackColor];
    self.profileImage.userInteractionEnabled = YES;
    self.profileImage.frame = CGRectMake(self.profileImage.frame.origin.x,self.profileImage.frame.origin.y, 150, 150);
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/1.5;
    self.profileImage.clipsToBounds = YES;
    
    self.originalProfileImage.file = PFUser.currentUser[@"profileImage"];
    [self.originalProfileImage loadInBackground];
    
    [self.view addSubview:self.profileImage];
}

-(void)createNameTextField {
    self.displayedName = [[UITextField alloc]init];
    self.displayedName.placeholder = @"Name";
    self.displayedName.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.displayedName];
}

-(void)createBioTextView {
    self.profileBio = [[UITextView alloc]init];
    
    self.profileBio.delegate = self;
    self.profileBio.text = @"Enter Bio..";
    self.profileBio.backgroundColor = [UIColor grayColor];
    
    
    //self.profileBio.backgroundColor = [UIColor grayColor];
    
    self.profileBio.font = [UIFont fontWithName:@"Arial" size:14];
    [self.view addSubview:self.profileBio];
}

-(void) createInterestLabel {
    self.interestsLabel = [[UILabel alloc] init];
    self.interestsLabel.textColor = [UIColor blackColor];
    self.interestsLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.interestsLabel.numberOfLines = 0;
    self.interestsLabel.text = @"Which of the following political issues are you interested in?";
    [self.view addSubview:self.interestsLabel];
}

-(void) createVotingLabel{
    self.votingLabel = [[UILabel alloc] init];
    self.votingLabel.textColor = [UIColor blackColor];
    self.votingLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.votingLabel.numberOfLines = 0;
    self.votingLabel.text = @"Are you a registered voter?";
    [self.view addSubview:self.votingLabel];
}

-(void)createVoterSwitch {
    self.voterSwitch = [[UISwitch alloc]init];
    self.voterSwitch.selected = NO;
    self.voterSwitch.tintColor = [UIColor blueColor];
    [self.view addSubview:self.voterSwitch];
}

-(void)createPlaceHolderText {
    // text view placeholder text
    CGRect placeholderFrame = CGRectMake(5, 70, self.view.frame.size.width - 10, 40);
    self.placeholderLabel = [[UILabel alloc] initWithFrame:placeholderFrame];
    self.placeholderLabel.text = @"  Tell us why!";
    self.placeholderLabel.textColor = [UIColor grayColor];
    self.placeholderLabel.font = [UIFont fontWithName:@"Montserrat-Regular.ttf" size:14.0];
    [self.profileBio addSubview:self.placeholderLabel];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.profileBio.text isEqualToString:@""]) {
        [self.placeholderLabel setHidden:NO];
    } else {
        [self.placeholderLabel setHidden:YES];
    }
}

#pragma mark - Actions

-(void) photoTapped {
    [self cameraViewPresented];
}

-(void) wholeViewTapped {
    [self.view endEditing:YES];
}

-(void)exitRegisterVC {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)finishedEditing {
    if(self.voterSwitch.selected){
        self.voter = YES;
    }
    else {
        self.voter = NO;
    }
    //[self completeUserRegistration];
    [CMMUser editUserInfo:self.profileImage.image withBio:self.profileBio.text withName:self.displayedName.text withInterests:self.interests andRegisteredVoter:self.voter withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    [self presentModalStatusView];
}

#pragma mark - ImagePicker

- (void)cameraViewPresented {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void) cameraRollViewPresented {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Do something with the images
    editedImage = [self resizeImage:originalImage withSize:CGSizeMake(200, 200)];
    self.profileImage.image = editedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - TableView
//TABLEVIEW CODE
- (void) createTableViewOne {
    self.tableViewOne = [[UITableView alloc] init];
    self.tableViewOne.delegate = self;
    self.tableViewOne.dataSource = self;
    self.tableViewOne.rowHeight = 30;
    self.tableViewOne.scrollEnabled = NO;
    [self.tableViewOne setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableViewOne setEditing:YES animated:NO];
    //self.tableView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.tableViewOne];
}

- (void) createtableViewTwo {
    self.tableViewTwo = [[UITableView alloc] init];
    self.tableViewTwo.delegate = self;
    self.tableViewTwo.dataSource = self;
    self.tableViewTwo.rowHeight = 30;
    self.tableViewTwo.scrollEnabled = NO;
    [self.tableViewTwo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableViewTwo setEditing:YES animated:NO];
    // self.tableViewTwo.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.tableViewTwo];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestsCell *cell = [[InterestsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"interestsCell"];
    //cell.title.text = self.numbers[indexPath.row];
    // NSLog(@"%@",self.numbers[indexPath.row]);
    if(tableView == self.tableViewOne){
        [cell configureInterestsCell:self.tableOneCategories[indexPath.row]];
        cell.tintColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0) green:(CGFloat)(194.0/255.0) blue:(CGFloat)(77.0/255.0) alpha:1];
        return cell;
    }
    else {
        [cell configureInterestsCell:self.tableTwoCategories[indexPath.row]];
        cell.tintColor = [UIColor colorWithRed:(CGFloat)(153.0/255.0) green:(CGFloat)(194.0/255.0) blue:(CGFloat)(77.0/255.0) alpha:1];
        return cell;
    }
    return 0;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableOneCategories.count;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self tableView:tableView cellForRowAtIndexPath:indexPath] setSelected:TRUE];
    
    if (tableView == self.tableViewOne){
        NSString *interest = self.tableOneCategories[indexPath.row];
        [self.interests addObject:interest];
        self.chosenInterests = self.interests;
        NSLog(@"%@", self.interests);
    }
    else {
        NSString *interest = self.tableTwoCategories[indexPath.row];
        [self.interests addObject:interest];
        self.chosenInterests = self.interests;
        NSLog(@"%@", self.interests);
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewOne){
        NSString *notInterest = self.tableOneCategories[indexPath.row];
        [self.interests removeObject:notInterest];
        self.chosenInterests = self.interests;
        NSLog(@"%@", self.interests);
    }
    else {
        NSString *notInterest = self.tableTwoCategories[indexPath.row];
        [self.interests removeObject:notInterest];
        self.chosenInterests = self.interests;
        NSLog(@"%@", self.interests);
    }
    //    NSString *notInterest = self.numbers[indexPath.row];
    //    [self.interests removeObject:notInterest];
    //    self.chosenInterests = self.interests;
    //    NSLog(@"%@", self.interests);
    
}

#pragma mark - Animation
-(void)presentModalStatusView {
    self.animationContainer = [[UIView alloc]init];
    [self.view addSubview:self.animationContainer];
    [self.animationContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.animationContainer.superview.mas_centerX);
        make.centerY.equalTo(self.animationContainer.superview.mas_centerY);
        make.width.equalTo(@(200));
        make.height.equalTo(@(200));
    }];
    
    self.lottieAnimation = [LOTAnimationView animationNamed:@"accountCreation"];
    
    self.lottieAnimation.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.lottieAnimation.loopAnimation = NO;
    
    self.lottieAnimation.contentMode = UIViewContentModeScaleAspectFit;
    CGRect lottieRect = CGRectMake(0, 0, (self.animationContainer.bounds.size.width), (self.animationContainer.bounds.size.height));
    self.lottieAnimation.frame = lottieRect;
    
    [self.animationContainer addSubview:self.lottieAnimation];
    [self.lottieAnimation playFromProgress:0.0 toProgress:0.8 withCompletion:^(BOOL animationFinished) {
        if (animationFinished) {
            [self.animationContainer removeFromSuperview];
            CMMMainTabBarVC *tabBarVC = [[CMMMainTabBarVC alloc] init];
            [self presentViewController:tabBarVC animated:YES completion:^{}];
        }
    }];
    
}

-(void) removeSelf: (UIView *)view {
    // Animate removal of view
    [view removeFromSuperview];
}

#pragma mark - Extra
// Create alert with given message and title
- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter Bio.."]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@""]) {
        textView.text = @"Enter Bio..";
    }
    [textView resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.displayedName resignFirstResponder];
    [self.profileBio resignFirstResponder];
}

-(void)createTapGestureRecognizer:(SEL)selector with:(id)object {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.cancelsTouchesInView = NO;
    [object addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

