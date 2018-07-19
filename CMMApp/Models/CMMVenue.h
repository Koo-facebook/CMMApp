//
//  CMMVenue.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CMMVenue : PFObject<PFSubclassing>
    
@property NSString *_Nullable address1;
@property NSString *_Nullable address2;
@property NSString *_Nullable city;
@property NSString *_Nullable region;
@property NSString *_Nullable postalCode;
@property NSString *_Nullable country;
@property NSNumber *_Nullable latitude;
@property NSNumber *_Nullable longitude;
@property NSString *_Nullable addressText;
@property NSString *_Nullable area;
    
- (instancetype _Nonnull )initWithDictionary: (NSDictionary *_Nonnull)venueDictionary;
    
@end
