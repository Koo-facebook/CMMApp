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
    
@property PFFile * _Nullable profileImage; // users profile image
@property NSMutableArray *_Nullable preferences; // users set preferences (if any)
@property NSMutableArray *_Nullable posts; // users posts
@property NSMutableArray *_Nullable conversations; // users conversations
    
+ (void)createUserWithCompletion: (NSString *_Nonnull)username password:(NSString *_Nonnull)password withCompletion:(PFBooleanResultBlock  _Nullable)completion;
+ (PFFile *_Nullable)getPFFileFromImage: (UIImage * _Nullable)image;
    
@end
