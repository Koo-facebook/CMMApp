//
//  CMMMessage.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMMessage.h"

@implementation CMMMessage
    
    @dynamic content;
    @dynamic attachment;
    @dynamic conversationId;
    
    + (nonnull NSString *)parseClassName {
        return @"CMMMessage";
    }
    
    + (void)createMessage:(CMMConversation *_Nonnull)conversation content:(NSString *_Nonnull)content attachment:(PFFile *_Nullable)attachment withCompletion:(PFBooleanResultBlock _Nullable)completion {
        
        CMMMessage *newMessage = [CMMMessage new];
        
        newMessage.conversationId = conversation.objectId;
        newMessage.content = content;
        newMessage.attachment = attachment;
        
        [newMessage saveInBackgroundWithBlock:completion];
    }
    
@end
