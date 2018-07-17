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
    @dynamic posts;
    @dynamic conversations;
    
    +(void)createUser: (NSString *_Nonnull)username password:(NSString *_Nonnull)password{
        CMMUser *newUser = [CMMUser new];
        newUser.username = username;
        newUser.password = password;
        newUser.preferences = [[NSMutableArray alloc] init];
        newUser.posts = [[NSMutableArray alloc] init];
        newUser.conversations = [[NSMutableArray alloc] init];
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
            }
        }];
    }
    
@end
