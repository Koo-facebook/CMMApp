//
//  CMMParseQueryManager.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMParseQueryManager.h"
#import <DateTools.h>
#import "UIImageView+AFNetworking.h"
@implementation CMMParseQueryManager

+ (instancetype)shared {
    static CMMParseQueryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)addBlockedUser:(CMMUser *)user Sender:(id)sender {
    if ([user.objectId isEqualToString:CMMUser.currentUser.objectId]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Don't block yourself!" message:@"That would be weird." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];
        [sender presentViewController:alert animated:YES completion:^{
        }];
        return;
    }
    NSString *blockingKey = [CMMUser.currentUser.objectId stringByAppendingString:@"-blockedUsers"];
    NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
    for (NSString *userID in blockedUsers) {
        if ([userID isEqualToString:user.objectId]) {
            return;
        }
    }
    [blockedUsers addObject:user.objectId];
    NSLog(@"Blocked users: %@", blockedUsers);
    [[NSUserDefaults standardUserDefaults] setObject:blockedUsers forKey:blockingKey];
}

- (void)deleteObjectFromParse:(PFObject *)object {
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"succeeded");
        }
    }];
}

- (void)addStrikeToUser:(CMMUser *)user {
    int newStrikes;
    if (user.strikes) {
        newStrikes = user.strikes.intValue + 1;
    } else {
        newStrikes = 1;
    }
    NSNumber *newStrikesNumber = [NSNumber numberWithInt:newStrikes];
    [user setObject:newStrikesNumber forKey:@"strikes"];
    //user.strikes = newStrikesNumber;
    [user saveInBackground];
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
    /*[query includeKey:@"owner.objectId"];
    NSString *blockingKey = [CMMUser.currentUser.objectId stringByAppendingString:@"-blockedUsers"];
    NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
    for (NSString *blockID in blockedUsers) {
        [query whereKey:@"owner.objectId" notEqualTo:blockID];
    }*/
    NSNumber *three = [NSNumber numberWithInteger:3];
    [query whereKey:@"owner.strikes" notEqualTo:three];
    if (trending) {
        [self updateTrendingLimit:number WithCompletion:^(NSError *error) {
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
        query.limit = number;
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

- (void)fetchPosts:(int)number ByAuthor:(CMMUser *)user WithCompletion:(void(^)(NSArray *posts, NSError *error)) completion {
    PFQuery *query;
    query = [PFQuery queryWithClassName:@"CMMPost"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"owner" equalTo:user];
    [query includeKey:@"owner"];
    query.limit = number;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            completion(posts, nil);
        }
    }];
}

- (void)updateTrendingLimit:(int)limit WithCompletion:(void(^)(NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"CMMPost"];
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            for (CMMPost *post in posts) {
                float trendingIndex = 0;
                for (NSDate *time in post.userChatTaps) {
                    trendingIndex += (1 / [[NSDate date] minutesFrom:time]);
                }
                post.trendingIndex = trendingIndex;
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

- (void)fetchConversationMessagesWithCompletion:(CMMConversation *)conversation skipCount:(NSInteger)skipCount withCompletion: (void(^)(NSArray *messages, NSError *error)) completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversation = %@", conversation];
    PFQuery *query = [PFQuery queryWithClassName:@"CMMMessage" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"messageSender"];
    [query includeKey:@"conversation"];
    query.limit = 20;
    query.skip = skipCount;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable messages, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            completion(messages, nil);
        }
    }];
    
}



@end
