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
- (void)fetchConversationMessagesWithCompletion:(NSString *)conversationIdString withCompletion: (void(^)(NSArray *messages, NSError *error))completion;
- (void)fetchConversationsWithCompletion:(void(^)(NSArray *conversations, NSError *error))completion;
- (void)fetchPosts:(int)number Categories:(NSArray *)categories WithCompletion:(void(^)(NSArray *posts, NSError *error))completion;
- (void)fetchUsersPostsWithCompletion:(CMMUser *)user withCompletion:(void(^)(NSArray *posts, NSError *error)) completion;

@end
