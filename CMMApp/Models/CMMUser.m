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
    
+ (void)createUser: (NSString *_Nonnull)username password:(NSString *_Nonnull)password withCompletion:(PFBooleanResultBlock  _Nullable)completion{
    CMMUser *newUser = [CMMUser new];
    newUser.username = username;
    newUser.password = password;
    newUser.preferences = [NSMutableArray new];
    newUser.profileImage = [CMMUser getPFFileFromImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    newUser.online = NO;
    
    [newUser signUpInBackgroundWithBlock:completion];
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
