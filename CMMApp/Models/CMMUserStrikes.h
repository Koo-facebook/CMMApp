//
//  CMMUserStrikes.h
//  CMMApp
//
//  Created by Olivia Jorasch on 8/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Parse.h>

@interface CMMUserStrikes : PFObject <PFSubclassing>
@property (strong, nonatomic) NSString * _Nullable userID;
@property (strong, nonatomic) NSNumber * _Nullable strikes;
+ (void)createStrikes:(NSNumber *_Nullable)number forUserID:(NSString *_Nullable)userID withCompletion:(void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, CMMUserStrikes *userStrikes))completion;
@end
