//
//  CMMConversation.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CMMConversation : PFObject
    
    @property NSMutableArray *_Nonnull users; // 2 users in conversation
    @property NSMutableArray *_Nonnull messages; // list of Messages in conversation
    
    +(void)createConversation:(NSMutableArray *_Nonnull)users withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
    @end
