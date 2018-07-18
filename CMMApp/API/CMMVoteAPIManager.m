//
//  CMMVoteAPIManager.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMVoteAPIManager.h"

@implementation CMMVoteAPIManager
    
    + (instancetype)shared {
        static CMMVoteAPIManager *sharedManager = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[self alloc] init];
        });
        return sharedManager;
    }
    
    - (void)registerVoter:(CMMVote *)vote withCompletion:(void(^)(NSDictionary *result, NSError *error))completion {
        NSMutableDictionary *voteDictionary = [self turnVoteIntoParams:vote];
        // make request w api key
    }
    
    - (NSMutableDictionary *)turnVoteIntoParams: (CMMVote *)vote {
        NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
        
        return returnDictionary;
    }

@end
