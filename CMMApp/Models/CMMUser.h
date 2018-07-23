//
//  CMMUser.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "PFUser.h"
#import <Parse/Parse.h>

@interface CMMUser : PFUser

@property (nonatomic, strong) PFFile * _Nullable profileImage; // users profile image
@property (nonatomic, strong) NSMutableArray *_Nullable preferences; // users set preferences (if any)
    
+ (void)createUser: (NSString *_Nonnull)username password:(NSString *_Nonnull)password withCompletion:(PFBooleanResultBlock  _Nullable)completion;
+ (void) editUserInfo: ( UIImage * _Nullable )image withBio: ( NSString * _Nullable )bio withName:( NSString * _Nullable )name withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFile *_Nullable)getPFFileFromImage: (UIImage * _Nullable)image;
    
@end
