//
//  CMMConversation.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMConversation.h"

@implementation CMMConversation
    
@dynamic users;
@dynamic messages;
@dynamic post;
@dynamic userOneRead;
@dynamic userTwoRead;
    
+ (nonnull NSString *)parseClassName {
    return @"CMMConversation";
}
    
+(void)createConversation:(NSMutableArray *_Nonnull)users withCompletion: (PFBooleanResultBlock  _Nullable)completion {
        
    CMMConversation *newConversation = [CMMConversation new];
    newConversation.users = users;
    newConversation.messages = [[NSMutableArray alloc] init];
        
    [newConversation saveInBackgroundWithBlock: completion];
}
    
@end
