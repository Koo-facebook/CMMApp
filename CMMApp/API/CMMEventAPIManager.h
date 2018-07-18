//
//  CMMEventAPIManager.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMEvent.h"

@interface CMMEventAPIManager : NSObject {
    NSDictionary *categories;
}
    
@property (nonatomic, retain) NSDictionary *categories;
    
+ (instancetype)shared;
    
- (void)getAllEvents:(void(^)(NSArray *events, NSError *error))completion;
- (void)searchEvents:(NSDictionary *)parameters withCompletion:(void(^)(NSArray *events, NSError *error))completion;
- (void)pullCategories:(void(^)(NSDictionary *categories, NSError *error))completion;
- (void)pullVenues:(NSString *)venue_id withCompletion:(void(^)(NSDictionary *venue, NSError *error))completion;

@end
