//
//  CMMPost.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMUser.h"

@interface CMMPost : PFObject<PFSubclassing>
    
    @property CMMUser *_Nonnull owner;
    @property NSString *_Nonnull question;
    @property NSString *_Nullable content;
    @property NSMutableArray *_Nullable categories;
    @property NSMutableArray *_Nullable tags;
    @property NSMutableArray *_Nullable agreeingUsers;
    @property NSMutableArray *_Nullable disagreeingUsers;
    
    + (void)createPost:(NSString *_Nonnull)question description:(NSString *_Nullable)description categories:(NSMutableArray *_Nullable)categories tags:(NSMutableArray *_Nullable)tags withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
@end
