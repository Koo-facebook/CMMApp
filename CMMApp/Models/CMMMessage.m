//
//  CMMMessage.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMMessage.h"

@implementation CMMMessage

@dynamic conversation;
@dynamic messageSender;
@dynamic content;
@dynamic attachment;

    
+ (nonnull NSString *)parseClassName {
    return @"CMMMessage";
}
    
+ (void)createMessage:(CMMConversation *_Nonnull)conversation content:(NSString *_Nonnull)content attachment:(PFFile *_Nullable)attachment withCompletion:(void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, CMMMessage * _Nullable message))completion {
        
    CMMMessage *newMessage = [CMMMessage new];
        
    newMessage.conversation = conversation;
    newMessage.content = content;
    newMessage.attachment = attachment;
    newMessage.messageSender = CMMUser.currentUser;

    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error, newMessage);
    }];
    
    if ([newMessage.messageSender.objectId isEqualToString:conversation.user1.objectId]) {
        conversation.userOneRead = YES;
        conversation.userTwoRead = NO;
    } else {
        conversation.userTwoRead = YES;
        conversation.userOneRead = NO;
    }
    
    newMessage.conversation.lastMessageSent = newMessage.createdAt;
    [newMessage.conversation saveInBackground];
}
    
@end
