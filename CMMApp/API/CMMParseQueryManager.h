//
//  CMMParseQueryManager.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/19/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"

@interface CMMParseQueryManager : NSObject

+ (instancetype)shared;
- (void)fetchConversationMessagesWithCompletion:(NSString *)idString withCompletion: (void(^)(NSArray *messages, NSError *error))completion;
- (void)fetchConversationsWithCompletion:(void(^)(NSArray *conversations, NSError *error))completion;
- (void)fetchPostsWithCompletion:(void(^)(NSArray *posts, NSError *error))completion;

@end
