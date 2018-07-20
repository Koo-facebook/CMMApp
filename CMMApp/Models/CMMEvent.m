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
@dynamic latitude;
@dynamic longitude;


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
        //if (![dictionary[@"venue_id"] isKindOfClass:[NSNull class]]) {
        [sharedManager pullVenues:dictionary[@"venue_id"] withCompletion:^(NSDictionary *venue, NSError *error) {
            self.venue = [[CMMVenue new] initWithDictionary:venue];
            self.latitude = self.venue.latitude;
            self.longitude = self.venue.longitude;
            /*if (venue) {
                self.category = sharedManager.categories[dictionary[@"category_id"]];
                self.url = dictionary[@"url"];
                self.title = dictionary[@"name"][@"text"];
                self.details = dictionary[@"description"][@"text"];
                self.category = sharedManager.categories[dictionary[@"category_id"]];
                self.startTime = dictionary[@"start"][@"local"];
                self.endTime = dictionary[@"end"][@"local"];
                self.onlineOnly = dictionary[@"online_event"];
            }*/
        }];
        //}
        self.category = sharedManager.categories[dictionary[@"category_id"]];
        self.url = dictionary[@"url"];
        self.title = dictionary[@"name"][@"text"];
        self.details = dictionary[@"description"][@"text"];
        self.category = sharedManager.categories[dictionary[@"category_id"]];
        self.startTime = dictionary[@"start"][@"local"];
        self.endTime = dictionary[@"end"][@"local"];
        self.onlineOnly = dictionary[@"online_event"];
    }
    return self;
}
    
@end
