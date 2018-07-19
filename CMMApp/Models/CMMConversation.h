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
    
@property (nonatomic, weak) CMMUser *_Nullable user1;
@property (nonatomic, weak) CMMUser *_Nullable user2;
@property (nonatomic, strong) NSMutableArray *_Nullable messages; // list of Messages in conversation
@property (nonatomic, strong) NSString *_Nonnull topic;
@property BOOL userOneRead;
@property BOOL userTwoRead;
    
+(void)createConversation:(CMMUser *_Nonnull)user2 topic:(NSString *_Nullable)topic withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
@end
