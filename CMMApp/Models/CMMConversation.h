//
//  CMMConversation.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CMMPost.h"

@interface CMMConversation : PFObject <PFSubclassing>

@property (nonatomic, strong) CMMUser *_Nullable user1;
@property (nonatomic, strong) CMMUser *_Nullable user2;
@property (nonatomic, strong) NSString *_Nonnull topic;
@property (nonatomic, strong) CMMUser *_Nullable userWhoLeft;
@property (nonatomic, strong) NSDate *_Nonnull lastMessageSent;
@property BOOL userOneRead;
@property BOOL userTwoRead;
@property (nonatomic, strong) NSMutableArray *_Nullable reportedUsers;
@property (nonatomic, strong) NSString *_Nullable reportedReason;
    
+ (void)createConversation:(CMMUser *_Nonnull)user2 topic:(NSString *_Nullable)topic withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, CMMConversation * _Nullable conversation))completion;
    
@end
