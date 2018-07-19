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

@interface CMMConversation : PFObject
    
@property (nonatomic, strong) NSMutableArray *_Nonnull users; // 2 users in conversation
@property (nonatomic, strong) NSMutableArray *_Nullable messages; // list of Messages in conversation
@property (nonatomic, strong) CMMPost *_Nonnull post;
@property BOOL userOneRead;
@property BOOL userTwoRead;
    
+(void)createConversation:(NSMutableArray *_Nonnull)users withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
@end
