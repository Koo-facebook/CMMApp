//
//  CMMVoteAPIManager.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CMMVote.h"
#import <Parse/Parse.h>

@interface CMMVoteAPIManager : NSObject
    
    + (instancetype)shared;
    
    //- (void)registerVoter:(CMMVote *)vote withCompletion:(void(^)(NSDictionary *result, NSError *error))completion;

@end
