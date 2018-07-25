//
//  CMMPost.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CMMUser.h"

@interface CMMPost : PFObject<PFSubclassing>

@property (nonatomic, weak) CMMUser *_Nullable owner;
@property (nonatomic, strong) NSString *_Nonnull topic;
@property (nonatomic, strong) NSString *_Nullable detailedDescription;
@property (nonatomic, strong) NSString *_Nullable category;
@property (nonatomic, strong) NSMutableArray *_Nullable tags;
@property (nonatomic, strong) NSMutableArray *_Nullable userChatTaps;
    
+ (void)createPost:(NSString *_Nonnull)topic description:(NSString *_Nullable)description category:(NSString *_Nullable)category tags:(NSMutableArray *_Nullable)tags withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
@end
