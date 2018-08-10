//
//  CMMResourcesAPIManager.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMMResourcesAPIManager : NSObject

+ (instancetype)shared;

- (void)getNewsArticlesWithTopic:(NSString *)topic fromDate:(NSString *)date withCompletion:(void(^)(NSArray *articles, NSError *error))completion;
-(void)getTrendingArticlesWithCompletion:(void(^)(NSArray *articles, NSError *error))completion;

@end
