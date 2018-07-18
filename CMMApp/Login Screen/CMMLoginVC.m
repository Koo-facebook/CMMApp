//
//  CMMLoginVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMLoginVC.h"
#import "Parse.h"

@interface CMMLoginVC ()
    
    @end

@implementation CMMLoginVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
    
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    //Dismissing the keyboard
    [self.overallView endEditing:YES];
}
    
    
- (IBAction)tappedSignUp:(UIButton *)sender {
    [self registerUser];
}
    
    
- (IBAction)tappedLogin:(id)sender {
    [self loginUser];
}
    
- (void)checkTextFieldsAlert {
    //initialize alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Problem" message:@"Either username or password is empty" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action button for alert
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    //Show the view controller
    [self presentViewController:alert animated:YES completion:^{
    }];
}
    
- (void)errorWithLogin {
    //initialize alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"There was a problem logging in. Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action button for alert
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    //Show the view controller
    [self presentViewController:alert animated:YES completion:^{
    }];
}
    
- (void)errorWithSignUp {
    //initialize alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error" message:@"There was a problem signing up. Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action button for alert
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    //Show the view controller
    [self presentViewController:alert animated:YES completion:^{
    }];
}
    
- (void)loginUser {
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    
    if ([self.usernameText.text isEqualToString:@""] || [self.passwordText.text isEqualToString:@""]) {
        [self checkTextFieldsAlert];
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self errorWithLogin];
            } else {
                NSLog(@"User logged in successfully");
                // display chat view controller after successful login
                [self performSegueWithIdentifier:@"MoveToHome" sender:nil];
                
            }
        }];
    }
}
    
- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameText.text;
    //newUser.email = self.emailField.text;
    newUser.password = self.passwordText.text;
    
    if ([self.usernameText.text isEqualToString: @""] || [self.passwordText.text isEqualToString: @""]) {
        [self checkTextFieldsAlert];
    }
    else {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self errorWithSignUp];
            } else {
                NSLog(@"User registered successfully");
                //Dispaly chat view controller after successful registration
                [self performSegueWithIdentifier:@"MoveToHome" sender:nil];
            }
        }];
    }
}
    
    
    @end
