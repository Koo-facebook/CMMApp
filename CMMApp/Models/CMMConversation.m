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
@dynamic messages;
@dynamic topic;
@dynamic userOneRead;
@dynamic userTwoRead;
    
+ (nonnull NSString *)parseClassName {
    return @"CMMConversation";
}
    
+(void)createConversation:(CMMUser *_Nonnull)user2 topic:(NSString *_Nullable)topic withCompletion: (PFBooleanResultBlock  _Nullable)completion {
        
    CMMConversation *newConversation = [CMMConversation new];
    newConversation.user1 = CMMUser.currentUser;
    newConversation.user2 = user2;
    newConversation.messages = [[NSMutableArray alloc] init];
    newConversation.topic = topic;
    newConversation.userTwoRead = NO;
    newConversation.userOneRead = YES;
    
    [user2.conversations addObject:newConversation];
    [CMMUser.currentUser.conversations addObject:newConversation];
        
    [newConversation saveInBackgroundWithBlock: completion];
    [user2 saveInBackground];
    [CMMUser.currentUser saveInBackground];
}
    
@end
