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

@interface CMMEditProfileVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *numbers;
@property (strong, nonatomic) NSMutableArray *interests;
@property (strong, nonatomic) NSArray *chosenInterests;

@end

@implementation CMMEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[InterestsCell class] forCellReuseIdentifier:@"interestsCell"];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.numbers = [[NSArray alloc]initWithObjects:@"Social Issues",@"Education", @"Criminal Issues", @"Economics", @"Global",@"Elections", @"Environment", @"Foreign Policy", @"Healthcare", @"Immigration", @"Local Politics", @"National Security", nil];
    self.interests = [[NSMutableArray alloc]init];
    self.chosenInterests = [[NSArray alloc]init];
    
    //[self createLabel];
    [self createCancelButton];
    [self createSubmitButton];
    [self createBioTextView];
    [self createNameTextField];
    [self createTapPhotoLabel];
    [self createProfileImageContainer];
    [self createtableView];
    [self updateConstraints];
    
    [self.tableView reloadData];
    [self createTapGestureRecognizer:@selector(photoTapped) with:self.profileImage];
    [self createTapGestureRecognizer:@selector(wholeViewTapped) with:self.view];
}

- (void)updateConstraints {
    //Profile Image Container
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.superview.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(200));
        make.width.equalTo(@(200));
    }];
    //Name TextField
    [self.displayedName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(30));
        make.width.equalTo(@(325));
    }];
    //Bio TextField
    [self.profileBio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayedName.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(75));
        make.width.equalTo(@(325));
    }];
    
    //Tap Photo Label
    [self.tapPhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(self.tapPhotoLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.tapPhotoLabel.intrinsicContentSize.width));
    }];
    
    //tableView (left)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileBio.mas_bottom).offset(25);
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        //make.left.equalTo(self.view.mas_left);//.offset(25);
        make.width.equalTo(@(325));
    }];
    
    
}

//CREATING ELEMENTS
-(void)createCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(exitEditingVC)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void)createSubmitButton {
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(finishedEditing)];
    self.navigationItem.rightBarButtonItem = editButton;
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
    self.profileBio.backgroundColor = [UIColor grayColor];
    self.profileBio.font = [UIFont fontWithName:@"Arial" size:14];
    [self.view addSubview:self.profileBio];
}

-(void) createTapPhotoLabel{
    self.tapPhotoLabel = [[UILabel alloc] init];
    self.tapPhotoLabel.textColor = [UIColor whiteColor];
    self.tapPhotoLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.tapPhotoLabel.numberOfLines = 1;
    self.tapPhotoLabel.text = @"Tap to Add Profile Photo";
    [self.view addSubview:self.tapPhotoLabel];
}
//
//-(void)createVoterQuestion {
//    self.s
//}
//
//-(void)createVoterSwitch {
//
//}

//ACTIONS
-(void)createTapGestureRecognizer:(SEL)selector with:(id)object {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [object addGestureRecognizer:tapGesture];
}

-(void) photoTapped {
    [self cameraViewPresented];
}

-(void) wholeViewTapped {
    [self.view endEditing:YES];
}

-(void)exitRegisterVC {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)finishedEditing {
    [CMMUser editUserInfo:self.profileImage.image withBio:self.profileBio.text withName:self.displayedName.text withInterests:self.chosenInterests andRegisteredVoter:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {

        //[self dismissViewControllerAnimated:YES completion:^{}];
    }];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//IMAGEPICKER CODE
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

//TABLEVIEW CODE
- (void) createtableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setEditing:YES animated:YES];
    //self.tableView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.tableView];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestsCell *cell = [[InterestsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"interestsCell"];
    //cell.title.text = self.numbers[indexPath.row];
    // NSLog(@"%@",self.numbers[indexPath.row]);
    [cell configureInterestsCell:self.numbers[indexPath.row]];
    cell.tintColor = [UIColor redColor];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numbers.count;
}

//TABLEVIEW CHECKMARK CODE
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *interest = self.numbers[indexPath.row];
    [self.interests addObject:interest];
    self.chosenInterests = self.interests;
    NSLog(@"%@", self.interests);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *notInterest = self.numbers[indexPath.row];
    [self.interests removeObject:notInterest];
    self.chosenInterests = self.interests;
    NSLog(@"%@", self.interests);
    
}

@end
