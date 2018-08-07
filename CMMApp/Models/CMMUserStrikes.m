//
//  CMMUserStrikes.m
//  CMMApp
//
//  Created by Olivia Jorasch on 8/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMUserStrikes.h"

@implementation CMMUserStrikes

@dynamic userID;
@dynamic strikes;
@dynamic reportedReasons;

+ (nonnull NSString *)parseClassName {
    return @"CMMUserStrikes";
}

+ (void)createStrikes:(NSNumber *)number forUserID:(NSString *)userID withCompletion:(void(^)(BOOL succeeded, NSError * _Nullable error, CMMUserStrikes *userStrikes))completion {
    CMMUserStrikes *userStrikes = [[CMMUserStrikes alloc] init];
    userStrikes.userID = userID;
    userStrikes.strikes = number;
    [userStrikes saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error, userStrikes);
    }];
}

@end
