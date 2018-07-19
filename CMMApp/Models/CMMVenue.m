//
//  CMMVenue.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMVenue.h"

@implementation CMMVenue
    
@dynamic address1;
@dynamic address2;
@dynamic city;
@dynamic region;
@dynamic postalCode;
@dynamic country;
@dynamic latitude;
@dynamic longitude;
@dynamic addressText;
@dynamic area;
    
+ (nonnull NSString *)parseClassName {
    return @"CMMVenue";
}
    
- (instancetype)initWithDictionary:(NSDictionary *)venueDictionary {
    self = [super init];
    if (self) {
        self.address1 = venueDictionary[@"address_1"];
        self.address2 = venueDictionary[@"address_2"];
        self.city = venueDictionary[@"city"];
        self.region = venueDictionary[@"region"];
        self.postalCode = venueDictionary[@"postal_code"];
        self.country = venueDictionary[@"country"];
        self.latitude = venueDictionary[@"latitude"];
        self.longitude = venueDictionary[@"longitude"];
        self.addressText = venueDictionary[@"localized_address_display"];
        self.area = venueDictionary[@"localized_area_display"];
    }
    return self;
}
    
@end
