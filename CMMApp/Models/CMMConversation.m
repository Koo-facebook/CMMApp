//
//  CMMConversation.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMConversation.h"

@implementation CMMConversation

@dynamic user1;
@dynamic user2;
@dynamic topic;
@dynamic lastMessageSent;
@dynamic userOneRead;
@dynamic userTwoRead;
@dynamic reportedUsers;
@dynamic userWhoLeft;
@dynamic reportedReason;
    
+ (nonnull NSString *)parseClassName {
    return @"CMMConversation";
}
    
+ (void)createConversation:(CMMUser *_Nonnull)user2 topic:(NSString *_Nullable)topic withCompletion: (void(^)(BOOL succeeded, NSError * _Nullable error, CMMConversation *conversation))completion {
        
    CMMConversation *newConversation = [CMMConversation new];
    newConversation.user1 = CMMUser.currentUser;
    newConversation.user2 = user2;
    newConversation.topic = topic;
    newConversation.userTwoRead = NO;
    newConversation.userOneRead = YES;
    
    [newConversation saveInBackground];
    
}
    
@end
