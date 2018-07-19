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
    @dynamic question;
    @dynamic content;
    @dynamic category;
    @dynamic tags;
    @dynamic agreeingUsers;
    @dynamic disagreeingUsers;
    
    + (nonnull NSString *)parseClassName {
        return @"CMMPost";
    }
    
    + (void)createPost:(NSString *)question description:(NSString *)description category:(NSString *)category tags:(NSMutableArray *)tags withCompletion: (PFBooleanResultBlock  _Nullable)completion {
        
        CMMPost *newPost = [CMMPost new];
        newPost.owner = CMMUser.currentUser;
        newPost.question = question;
        newPost.content = description;
        newPost.category = category;
        newPost.tags = tags;
        newPost.agreeingUsers = [[NSMutableArray alloc] init];
        newPost.disagreeingUsers = [[NSMutableArray alloc] init];
        
        [newPost saveInBackgroundWithBlock:completion];
    }
    
    @end
