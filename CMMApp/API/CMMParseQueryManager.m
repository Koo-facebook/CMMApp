//
//  CMMParseQueryManager.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMParseQueryManager.h"
#import <DateTools.h>

@implementation CMMParseQueryManager

+ (instancetype)shared {
    static CMMParseQueryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchPosts:(int)number Categories:(NSArray *)categories SortByTrending:(BOOL)trending WithCompletion:(void(^)(NSArray *posts, NSError *error)) completion {
    PFQuery *query;
    if (categories.count > 0) {
        NSMutableArray *queries = [[NSMutableArray alloc] init];
        for (NSString *category in categories) {
            PFQuery *categoryQuery = [PFQuery queryWithClassName:@"CMMPost"];
            [categoryQuery whereKey:@"category" equalTo:category];
            [queries addObject:categoryQuery];
        }
        query = [PFQuery orQueryWithSubqueries:queries];
    } else {
        query = [PFQuery queryWithClassName:@"CMMPost"];
    }
    [query includeKey:@"owner"];
    query.limit = number;
    if (trending) {
        [self updateTrendingWithCompletion:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                [query orderByDescending:@"trendingIndex"];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                    } else {
                        completion(posts, nil);
                    }
                }];
            }
        }];
    } else {
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                completion(posts, nil);
            }
        }];
    }
}

- (void)updateTrendingWithCompletion:(void(^)(NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"CMMPost"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            for (CMMPost *post in posts) {
                //NSLog(@"Post: %@", post.topic);
                float trendingIndex = 0;
                for (NSDate *time in post.userChatTaps) {
                    //NSLog(@"Adding to index: %f", (1 / [[NSDate date] minutesFrom:time]));
                    trendingIndex += (1 / [[NSDate date] minutesFrom:time]);
                }
                post.trendingIndex = trendingIndex;
                //NSLog(@"total index: %f", trendingIndex);
                [post saveInBackground];
            }
            completion(nil);
        }
    }];
}

- (void)fetchUsersPostsWithCompletion:(CMMUser *)user withCompletion:(void(^)(NSArray *posts, NSError *error)) completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner = %@", user];
    PFQuery *query = [PFQuery queryWithClassName:@"CMMPost" predicate:predicate];
    [query includeKey:@"owner"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            completion(posts, nil);
        }
    }];
}

- (void)fetchConversationsWithCompletion:(void(^)(NSArray *conversations, NSError *error)) completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user1 = %@) OR (user2 = %@)", CMMUser.currentUser, CMMUser.currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"CMMConversation" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable conversations, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            completion(conversations, nil);
        }
    }];
}

- (void)fetchConversationMessagesWithCompletion:(CMMConversation *)conversation withCompletion: (void(^)(NSArray *messages, NSError *error)) completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversation = ", conversation];
    PFQuery *query = [PFQuery queryWithClassName:@"CMMMessages" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"messageSender"];
    [query includeKey:@"conversation"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable messages, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            completion(messages, nil);
        }
    }];
    
}



@end
