//
//  CMMArticle.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMArticle.h"

@implementation CMMArticle

@dynamic url;
@dynamic title;
@dynamic details;
@dynamic source;
@dynamic dateWritten;
@dynamic author;
@dynamic imageUrl;

+ (nonnull NSString *)parseClassName {
    return @"CMMArticle";
}

+ (NSMutableArray *)articlesWithArray:(NSArray *)dictionaries{
    NSMutableArray *articles = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        CMMArticle *article = [[CMMArticle alloc] initWithDictionary:dictionary];
        [articles addObject:article];
    }
    return articles;
}

- (instancetype)initWithDictionary:(NSDictionary *)articleDictionary {
    self = [super init];
    if (self) {
        self.url= articleDictionary[@"url"];
        self.title = articleDictionary[@"title"];
        self.details = articleDictionary[@"description"];
        self.source = articleDictionary[@"source"];
        self.dateWritten = articleDictionary[@"publishedAt"];
        self.author = articleDictionary[@"author"];
        self.imageUrl = articleDictionary[@"urlToImage"];
    }
    return self;
}

@end

