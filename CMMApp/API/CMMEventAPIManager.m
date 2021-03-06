//
//  CMMEventAPIManager.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMEventAPIManager.h"
#import "CMMEvent.h"

@implementation CMMEventAPIManager

@synthesize categories;

+ (instancetype)shared {
    static CMMEventAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"eventCategories"]) {
            self.categories = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"eventCategories"];
        } else {
            [self pullCategories:^(NSDictionary *categories, NSError *error) {
                if (!error) {
                    [[NSUserDefaults standardUserDefaults] setObject:categories forKey:@"eventCategories"];
                    self.categories = categories;
                }
            }];
        }
    }
    return self;
}


- (void)getAllEventswithLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude withCompletion:(void(^)(NSArray *events, NSError *error))completion {
    //Formatting the URL
    NSString *baseURL = @"https://www.eventbriteapi.com/v3/events/search/?q=politics+government&sort_by=date&location.within=15mi&location.latitude=";
    NSString *addlatitude = [latitude stringValue];
    NSString *middleURL = @"&location.longitude=";
    NSString *addlongitude = [longitude stringValue];
    NSString *endURL = @"&token=YIQCSL5B666YAANPQXF5";
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, addlatitude, middleURL, addlongitude, endURL];
    NSLog(@"%@", fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        } else {
            NSLog(@"😎😎😎 Successfully got all events");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *eventsDictionaries = dataDictionary[@"events"];
            /*for (NSDictionary *event in eventsDictionaries) {
             NSString *name = event[@"venue_id"];
             }*/
            NSArray *events = [CMMEvent eventsWithArray:eventsDictionaries];
            completion(events, nil);
        }
    }];
    [task resume];
}

- (void)searchEvents:(NSDictionary *)parameters withCompletion:(void(^)(NSArray *events, NSError *error))completion{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbriteapi.com/v3/events/search/?q=%@&token=YIQCSL5B666YAANPQXF5", [self returnParamString:parameters]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *eventsDictionaries = dataDictionary[@"results"];
            NSArray *events = [CMMEvent eventsWithArray:eventsDictionaries];
            completion(events, nil);
        }
    }];
    [task resume];
}

- (void)pullCategories:(void(^)(NSDictionary *categories, NSError *error))completion{
    NSURL *url = [NSURL URLWithString:@"https://www.eventbriteapi.com/v3/categories/?token=YIQCSL5B666YAANPQXF5"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *categoriesDictionaries = dataDictionary[@"categories"];
            NSDictionary *categoriesDictionary = [[NSDictionary alloc] init];
            for (NSDictionary *eachDictionary in categoriesDictionaries) {
                NSNumber *categoryId = eachDictionary[@"id"];
                NSString *idString = [NSString stringWithFormat:@"%@", categoryId];
                //[categoriesDictionary setValue:idString forKey:eachDictionary[@"short_name"]];
            }
            completion(categoriesDictionary, nil);
        }
    }];
    [task resume];
}

- (void)pullVenues:(NSString *)venue_id withCompletion:(void(^)(NSDictionary *venues, NSError *error))completion{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbriteapi.com/v3/venues/%@/?token=YIQCSL5B666YAANPQXF5", venue_id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *venues = dataDictionary[@"address"];
            //NSArray *venues = [CMMVenue venuesWithArray:venue];
            
            completion(venues, nil);
        }
    }];
    [task resume];
}

- (NSString *)returnParamString:(NSDictionary *)params {
    NSMutableString *finalString = [[NSMutableString alloc] init];
    for (NSString* each in [params allKeys]) {
        [finalString appendString:[NSString stringWithFormat:@"%@=%@&", each, params[each]]];
    }
    return finalString;
}

@end
