//
//  CMMEvent.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CMMEventAPIManager.h"
#import "CMMVenue.h"

@interface CMMEvent : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *_Nonnull url;
@property (nonatomic, strong) NSString *_Nonnull title;
@property (nonatomic, strong) NSString *_Nullable details;
@property (nonatomic, strong) NSString *_Nullable category;
@property (nonatomic, strong) NSString *_Nullable startTime;
@property (nonatomic, strong) NSString *_Nullable endTime;
@property (nonatomic, strong) NSString *_Nullable venue_id;
@property (nonatomic, strong) CMMVenue *_Nullable venue;
@property (nonatomic, strong) NSNumber *_Nullable latitude;
@property (nonatomic, strong) NSNumber *_Nullable longitude;

@property BOOL onlineOnly;
    
+ (NSMutableArray *_Nonnull)eventsWithArray:(NSArray *_Nonnull)dictionaries;
    
@end
