//
//  CMMEvent.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMEvent.h"

@implementation CMMEvent
    
@dynamic url;
@dynamic title;
@dynamic details;
@dynamic category;
@dynamic startTime;
@dynamic endTime;
@dynamic onlineOnly;
@dynamic venue;

+ (nonnull NSString *)parseClassName {
    return @"CMMEvent";
}

+ (NSMutableArray *)eventsWithArray:(NSArray *)dictionaries{
    NSMutableArray *events = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        CMMEvent *event = [[CMMEvent alloc] initWithDictionary:dictionary];
        [events addObject:event];
    }
    return events;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        CMMEventAPIManager *sharedManager = [CMMEventAPIManager shared];
        self.category = sharedManager.categories[dictionary[@"category_id"]];
        [sharedManager pullVenues:dictionary[@"venue_id"] withCompletion:^(NSDictionary *venue, NSError *error) {
            self.venue = [[CMMVenue new] initWithDictionary:venue];
        }];
        self.url = [NSURL URLWithString:dictionary[@"url"]];
        self.title = dictionary[@"name"];
        self.details = dictionary[@"description"];
        self.category = sharedManager.categories[dictionary[@"category_id"]];
        self.startTime = dictionary[@"start"][@"local"];
        self.endTime = dictionary[@"end"][@"local"];
        self.onlineOnly = dictionary[@"online_event"];
    }
    return self;
}
    
@end
