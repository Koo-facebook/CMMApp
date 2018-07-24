//
//  CMMPost.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMPost.h"

@implementation CMMPost

@dynamic owner;
@dynamic topic;
@dynamic detailedDescription;
@dynamic category;
@dynamic tags;
@dynamic agreeingUsersIds;
@dynamic disagreeingUsersIds;
    
+ (nonnull NSString *)parseClassName {
    return @"CMMPost";
}
    
+ (void)createPost:(NSString *)topic description:(NSString *)description category:(NSString *)category tags:(NSMutableArray *)tags withCompletion: (PFBooleanResultBlock  _Nullable)completion {
        
    CMMPost *newPost = [CMMPost new];
    newPost.owner = CMMUser.currentUser;
    newPost.topic = topic;
    newPost.detailedDescription = description;
    newPost.category = category;
    newPost.tags = tags;
    newPost.agreeingUsersIds = [NSMutableArray new];
    newPost.disagreeingUsersIds = [NSMutableArray new];
    
    [newPost saveInBackgroundWithBlock:completion];
    
}
    
@end
