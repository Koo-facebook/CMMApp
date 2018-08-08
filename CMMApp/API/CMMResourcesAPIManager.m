//
//  CMMResourcesAPIManager.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMResourcesAPIManager.h"
#import "CMMArticle.h"

@implementation CMMResourcesAPIManager

+ (instancetype)shared {
    static CMMResourcesAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)getNewsArticlesWithTopic:(NSString *)topic fromDate:(NSString *)date withCompletion:(void(^)(NSArray *articles, NSError *error))completion {
    //Formatting the URL
    NSString *baseURL = @"https://newsapi.org/v2/everything?";
    NSString *addTopic = [@"q=" stringByAppendingString:topic];
    NSString *addDate = [@"&from=" stringByAppendingString:date];
    NSString *endURL = @"&sources=the-washington-post&sortBy=popularity&apiKey=90618f0c88ef47eca97a30b24223381c";
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@", baseURL, addTopic, addDate, endURL];
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
            
            NSArray *articlesDictionaries = dataDictionary[@"articles"];
            /*for (NSDictionary *event in eventsDictionaries) {
             NSString *name = event[@"venue_id"];
             }*/
            NSArray *articles = [CMMArticle articlesWithArray:articlesDictionaries];
            completion(articles, nil);
        }
    }];
    [task resume];
}
@end
