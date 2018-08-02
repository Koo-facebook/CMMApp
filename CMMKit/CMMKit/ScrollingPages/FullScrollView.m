//
//  FullScrollView.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/31/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "FullScrollView.h"

@implementation FullScrollView

-(id)initWithFrame:(CGRect)frame andNumberOfPages:(NSInteger)pages {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentSize = CGSizeMake(pages * self.frame.size.width, self.frame.size.height);
        self.totalPages = pages;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.alwaysBounceVertical = NO;
        
    }
    
    return self;
}

-(void)configureViewAtIndexWithCompletion:(void(^)(UIView *view, NSInteger index, BOOL success))completion {
    if (!self.totalPages) {
        NSLog(@"No view were provided");
        completion(nil, 0, NO);
    } else {
        
        for (int i = 0; i < self.totalPages; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
            
            [self addSubview:view];
            
            self.pageControl = [[UIPageControl alloc] init];
            self.pageControl.frame = CGRectMake((view.frame.size.width/2.68),(view.frame.size.height/1.20),100,100);
            self.pageControl.numberOfPages = self.totalPages;
            self.pageControl.currentPage = i;
            [view addSubview:self.pageControl];
            
            completion(view, i, YES);
        }
    }
}

@end
