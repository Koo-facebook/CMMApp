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
    
+ (void)createUser: (NSString *_Nonnull)username password:(NSString *_Nonnull)password withCompletion:(PFBooleanResultBlock  _Nullable)completion{
    CMMUser *newUser = [CMMUser new];
    newUser.username = username;
    newUser.password = password;
    newUser.preferences = [NSMutableArray new];
    newUser.profileImage = [CMMUser getPFFileFromImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    
    [newUser signUpInBackgroundWithBlock:completion];
}

+ (void) editUserInfo: ( UIImage * _Nullable )image withBio: ( NSString * _Nullable )bio withName:( NSString * _Nullable )name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    PFUser *user = [PFUser currentUser];
    user[@"profileImage"] = [self getPFFileFromImage:image];
    //user.username = PFUser.currentUser.username;
    user[@"profileBio"] = bio;
    user[@"displayedName"] = name;
    
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
