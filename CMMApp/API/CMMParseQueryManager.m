//
//  CMMParseQueryManager.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMParseQueryManager.h"

@implementation CMMParseQueryManager

+ (instancetype)shared {
    static CMMParseQueryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchPostsWithCompletion:(void(^)(NSArray *posts, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"CMMPost"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"owner"];
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)fetchConversationsWithCompletion:(void(^)(NSArray *conversations, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"CMMConversation"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)fetchConversationMessagesWithCompletion:(NSString *)idString withCompletion: (void(^)(NSArray *messages, NSError *error)) completion {
    PFQuery *query = [PFQuery queryWithClassName:@"CMMMessages"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"messageSender"];
    [query findObjectsInBackgroundWithBlock:completion];
}



@end
