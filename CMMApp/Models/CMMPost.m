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
@dynamic userChatTaps;
@dynamic postLatitude;
@dynamic postLongitude;
@dynamic trendingIndex;
@dynamic reportedNumber;

+ (nonnull NSString *)parseClassName {
    return @"CMMPost";
}
    
+ (void)createPost:(NSString *_Nullable)topic description:(NSString *_Nullable)description category:(NSString *_Nullable)category tags:(NSMutableArray *_Nullable)tags withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, CMMPost * _Nullable post))completion {
        
    CMMPost *newPost = [CMMPost new];
    newPost.owner = CMMUser.currentUser;
    newPost.topic = topic;
    newPost.detailedDescription = description;
    newPost.category = category;
    newPost.tags = tags;
    newPost.userChatTaps = [NSMutableArray new];
    newPost.trendingIndex = 0;
    newPost.reportedNumber = 0;
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error, newPost);
    }];
    
}
    
@end
