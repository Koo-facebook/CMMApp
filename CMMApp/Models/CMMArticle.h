//
//  CMMArticle.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CMMResourcesAPIManager.h"


@interface CMMArticle : PFObject <PFSubclassing>


@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *_Nonnull title;
@property (nonatomic, strong) NSString *_Nullable details;
@property (nonatomic, strong) NSString *_Nullable source;
@property (nonatomic, strong) NSString *_Nullable dateWritten;
@property (nonatomic, strong) NSString *_Nullable author;
@property (nonatomic, strong) NSURL *imageUrl;

+ (NSMutableArray *)articlesWithArray:(NSArray *)dictionaries;

@end

