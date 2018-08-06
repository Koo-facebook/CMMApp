//
//  CMMUser.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMUser.h"

@implementation CMMUser
    
@dynamic profileImage;
@dynamic interests;
@dynamic online;
@dynamic profileBio;
@dynamic displayName;
@dynamic strikes;
@dynamic voter;
    
+ (void)createUser: (NSString *_Nonnull)username password:(NSString *_Nonnull)password withCompletion:(void(^_Nullable)(BOOL succeeded, NSError * _Nullable error))completion{
    CMMUser *newUser = [CMMUser new];
    newUser.username = username;
    newUser.password = password;
    newUser.interests = [NSArray new];
    newUser.profileImage = [CMMUser getPFFileFromImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    newUser.online = @NO;
    newUser.strikes = @(0);
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error);
//        PFACL *userACL = [PFACL ACLWithUser:CMMUser.currentUser];
//        [userACL setPublicReadAccess:YES];
//        [userACL setPublicWriteAccess:YES];
//        CMMUser.currentUser.ACL = userACL;
//        [CMMUser.currentUser saveInBackground];
    }];
}

+ (void) editUserInfo: ( UIImage * _Nullable )image withBio: ( NSString * _Nullable )bio withName:( NSString * _Nullable )name withInterests:(NSArray *_Nullable)interests andRegisteredVoter: (BOOL)voter withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    CMMUser *user = [CMMUser currentUser];
    user.profileImage = [self getPFFileFromImage:image];
    //user.username = PFUser.currentUser.username;
    user.profileBio = bio;
    user.displayName = name;
    user.interests = interests;
    user.voter = voter;
    
    [user saveInBackgroundWithBlock: completion];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}

    
@end
