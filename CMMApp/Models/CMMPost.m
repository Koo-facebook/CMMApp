//
//  CMMPost.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMPost.h"
#import "CMMLanguageProcessor.h"

@implementation CMMPost

@dynamic owner;
@dynamic topic;
@dynamic detailedDescription;
@dynamic category;
@dynamic tags;
@dynamic userChatTaps;
@dynamic postLatitude;
@dynamic postLongitude;
@dynamic trendingIndex;
@dynamic reportedNumber;
@dynamic keyWords;
@dynamic lemmatizedVersion;

+ (nonnull NSString *)parseClassName {
    return @"CMMPost";
}
    
+ (void)createPost:(NSString *_Nullable)topic description:(NSString *_Nullable)description category:(NSString *_Nullable)category tags:(NSMutableArray *_Nullable)tags withCompletion: (void(^_Nullable)(BOOL succeeded, NSError * _Nullable error, CMMPost * _Nullable post))completion {
        
    CMMPost *newPost = [CMMPost new];
    [newPost getCurrentLocation];
    newPost.owner = CMMUser.currentUser;
    newPost.topic = topic;
    newPost.detailedDescription = description;
    newPost.category = category;
    newPost.tags = tags;
    newPost.userChatTaps = [NSMutableArray new];
    newPost.trendingIndex = 0;
    newPost.reportedNumber = @(0);
    [newPost lemmatizeTopic];
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded, error, newPost);
    }];
    
}

- (void) getCurrentLocation {
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Request Authorization
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // Start Updating Location only when user authorized us
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        [locationManager startUpdatingLocation];
        self.postLatitude = @(locationManager.location.coordinate.latitude);
        NSLog(@"%f", [self.postLatitude floatValue]);
        self.postLongitude = @(locationManager.location.coordinate.longitude);
        NSLog(@"%f", [self.postLongitude floatValue]);
    } else {
        self.postLongitude = nil;
        self.postLatitude = nil;
    }
}

- (void)lemmatizeTopic {
    self.lemmatizedVersion = [self stringifyArray:[CMMLanguageProcessor lemmatizeText:self.topic]];
}

- (NSString *)stringifyArray:(NSArray *)array {
    NSString *returnString = @"";
    for (NSString *string in array) {
        returnString = [returnString stringByAppendingString:string];
    }
    NSRange range = NSMakeRange(0, returnString.length-1);
    returnString = [returnString substringWithRange:range];
    return returnString;
}

- (NSArray *)getKeyWords {
    
    return [NSArray new];
}
    
@end
