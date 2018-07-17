//
//  CMMMessage.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CMMConversation.h"

@interface CMMMessage : PFObject<PFSubclassing>
    
@property NSString *_Nullable content;
@property PFFile *_Nullable attachment;
@property NSString *_Nonnull conversationId;
    
+ (void)createMessage:(CMMConversation *_Nonnull)conversation content:(NSString *_Nonnull)content attachment:(PFFile *_Nullable)attachment withCompletion:(PFBooleanResultBlock _Nullable)completion;
    
@end
