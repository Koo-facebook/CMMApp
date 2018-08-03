//
//  CMMParseQueryManager.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"
#import "CMMPost.h"
#import "CMMConversation.h"
#import "CMMMessage.h"

@interface CMMParseQueryManager : NSObject

+ (instancetype)shared;
- (void)fetchConversationMessagesWithCompletion:(CMMConversation *)conversation skipCount:(NSInteger)skipCount withCompletion: (void(^)(NSArray *messages, NSError *error)) completion;
- (void)fetchConversationsWithCompletion:(void(^)(NSArray *conversations, NSError *error))completion;
- (void)fetchPosts:(int)number Categories:(NSArray *)categories SortByTrending:(BOOL)trending Reported:(BOOL)reported WithCompletion:(void(^)(NSArray *posts, NSError *error))completion;
- (void)fetchPosts:(int)number ByAuthor:(CMMUser *)user WithCompletion:(void(^)(NSArray *posts, NSError *error)) completion;
- (void)fetchUsersPostsWithCompletion:(CMMUser *)user withCompletion:(void(^)(NSArray *posts, NSError *error)) completion;
- (void)addBlockedUser:(CMMUser *)user Sender:sender;
- (void)addStrikeToUser:(CMMUser *)user;
- (void)reportPost:(CMMPost *)post;
- (void)deletePostFromParse:(CMMPost *)post;
- (void)deleteMessageForConversation: (CMMConversation *)conversation withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error)) completion;
- (void)fetchNearbyPosts:(int)skip latitude:(float)latitude longitude:(float)longitude withCompletion: (void(^_Nullable)(NSArray * _Nullable posts, NSError * _Nullable error)) completion;
@end
