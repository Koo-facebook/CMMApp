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
@dynamic preferences;
@dynamic online;
@dynamic profileBio;
@dynamic displayName;
    
+ (void)createUser: (NSString *_Nonnull)username password:(NSString *_Nonnull)password withCompletion:(void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, CMMUser * _Nullable post))completion{
    CMMUser *newUser = [CMMUser new];
    newUser.username = username;
    newUser.password = password;
    newUser.preferences = [NSMutableArray new];
    newUser.profileImage = [CMMUser getPFFileFromImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    newUser.online = @NO;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error, newUser);
    }];
}

+ (void) editUserInfo: ( UIImage * _Nullable )image withBio: ( NSString * _Nullable )bio withName:( NSString * _Nullable )name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    CMMUser *user = [CMMUser currentUser];
    user.profileImage = [self getPFFileFromImage:image];
    //user.username = PFUser.currentUser.username;
    user.profileBio = bio;
    user.displayName = name;
    
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
