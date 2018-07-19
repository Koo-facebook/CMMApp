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
@dynamic categories;
@dynamic tags;
@dynamic agreeingUsers;
@dynamic disagreeingUsers;
    
+ (nonnull NSString *)parseClassName {
    return @"CMMPost";
}
    
+ (void)createPost:(NSString *)topic description:(NSString *)description categories:(NSMutableArray *)categories tags:(NSMutableArray *)tags withCompletion: (PFBooleanResultBlock  _Nullable)completion {
        
    CMMPost *newPost = [CMMPost new];
    newPost.owner = CMMUser.currentUser;
    newPost.topic = topic;
    newPost.detailedDescription = description;
    newPost.categories = categories;
    newPost.tags = tags;
    newPost.agreeingUsers = [[NSMutableArray alloc] init];
    newPost.disagreeingUsers = [[NSMutableArray alloc] init];
        
    [newPost saveInBackgroundWithBlock:completion];
}
    
@end
