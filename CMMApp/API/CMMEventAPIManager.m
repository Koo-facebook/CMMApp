//
//  CMMEventAPIManager.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMEventAPIManager.h"

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
    
    - (void)getAllEvents:(NSString *)endpoint withCompletion:(void(^)(NSArray *events, NSError *error))completion{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbriteapi.com/v3/%@?token=%@", endpoint, NSProcessInfo.processInfo.environment[@"eventAPISecret"]]];
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
    
    - (void)searchEvents:(NSString *)endpoint parameters:(NSDictionary *)parameters withCompletion:(void(^)(NSArray *events, NSError *error))completion{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbriteapi.com/v3/%@?%@token=%@", endpoint, [self returnParamString:parameters], NSProcessInfo.processInfo.environment[@"eventAPISecret"]]];
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbriteapi.com/v3/categies/?token=%@", NSProcessInfo.processInfo.environment[@"eventAPISecret"]]];
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
                    [categoriesDictionary setValue:idString forKey:eachDictionary[@"short_name"]];
                }
                completion(categoriesDictionary, nil);
            }
        }];
        [task resume];
    }
    
    - (void)pullVenues:(NSString *)venue_id withCompletion:(void(^)(NSDictionary *venue, NSError *error))completion{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.eventbriteapi.com/v3/venues/%@/?token=%@", venue_id, NSProcessInfo.processInfo.environment[@"eventAPISecret"]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                completion(nil, error);
            } else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *venueDictionary = dataDictionary[@"address"];
                completion(venueDictionary, nil);
            }
        }];
        [task resume];
    }
    
    - (NSString *)returnParamString:(NSDictionary *)params {
        NSMutableString *finalString = [[NSMutableString alloc] init];
        for (NSString* each in [params allKeys]) {
            [finalString appendString:[NSString stringWithFormat:@"%@=%@", each, params[each]]];
        }
        return finalString;
    }

@end
