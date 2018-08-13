//
//  CMMPost.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMPost.h"
#import "CMMLanguageProcessor.h"
#import "SentimentPolarity.h"

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
@dynamic overallSentiment;

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
    newPost.keyWords = [NSMutableArray new];
    [newPost lemmatizeTopic];
    [newPost classifySentiment];
    [newPost getKeyWords];
    
    
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
        returnString = [[returnString stringByAppendingString:string] stringByAppendingString:@" "];
    }
    NSRange range = NSMakeRange(0, returnString.length-1);
    returnString = [returnString substringWithRange:range];
    return returnString;
}

- (void)getKeyWords {
    NSMutableDictionary *namedEntities = [CMMLanguageProcessor namedEntityRecognition:self.topic];
    for (id key in namedEntities) {
        if (![self.keyWords containsObject:key]) {
            [self.keyWords addObject:key];
        }
    }
    
}

- (void)classifySentiment {
    NSDictionary *topicsSentiment = [CMMLanguageProcessor runSentimentAnalysis:self.topic];
    if (![self.detailedDescription isEqualToString:@""]) {
        NSDictionary *descriptionsSentiment = [CMMLanguageProcessor runSentimentAnalysis:self.detailedDescription];
    
        if ([topicsSentiment[@"classLabel"] isEqualToString:descriptionsSentiment[@"classLabel"]]) {
            if ([topicsSentiment[@"classLabel"] isEqualToString:@"Pos"]) {
                self.overallSentiment = YES;
            } else {
                self.overallSentiment = NO;
            }
        } else {
            double topicsSentimentValue = [self sentimentValue:topicsSentiment];
            double descriptionsSentimentValue = [self sentimentValue:descriptionsSentiment];
            
            if (topicsSentimentValue + descriptionsSentimentValue >= 0) {
                self.overallSentiment = YES;
            } else {
                self.overallSentiment = NO;
            }
        }
        
    } else {
        if ([topicsSentiment[@"classLabel"] isEqualToString:@"Pos"]) {
            self.overallSentiment = YES;
        } else {
            self.overallSentiment = NO;
        }
    }
}

- (double)sentimentValue:(NSDictionary *)sentiment {

    NSString *sentimentValue = sentiment[@"classLabel"];
    NSString *sentimentProb = sentiment[@"classProbability"];
    
    double sentimentNumber = 0.0;

    if ([sentimentValue isEqualToString:@"Pos"]) {
        sentimentNumber = 1.0;
    }
    
    sentimentNumber = sentimentNumber * [sentimentProb doubleValue];
    
    return sentimentNumber;
}
    
@end
