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
    
+ (void)createMessage:(CMMConversation *_Nonnull)conversation content:(NSString *_Nonnull)content attachment:(PFFile *_Nullable)attachment withCompletion:(PFBooleanResultBlock _Nullable)completion {
        
    CMMMessage *newMessage = [CMMMessage new];
        
    newMessage.conversation = conversation;
    newMessage.content = content;
    newMessage.attachment = attachment;
    newMessage.messageSender = CMMUser.currentUser;

    [newMessage saveInBackgroundWithBlock:completion];
    
}
    
@end
