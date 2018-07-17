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
    
    @property NSURL *_Nonnull url;
    @property NSString *_Nonnull title;
    @property NSString *_Nullable details;
    @property NSString *_Nullable category;
    @property NSDate *_Nullable startTime;
    @property NSDate *_Nullable endTime;
    @property CMMVenue *_Nullable venue;
    @property BOOL onlineOnly;
    
    + (NSMutableArray *_Nonnull)eventsWithArray:(NSArray *_Nonnull)dictionaries;
    
    @end
