//
//  FullScrollView.h
//  CMMKit
//
//  Created by Keylonnie Miller on 7/31/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScrollView : UIScrollView

@property NSInteger totalPages;
@property UIPageControl *pageControl;

-(id)initWithFrame:(CGRect)frame andNumberOfPages:(NSInteger)pages;

-(void)configureViewAtIndexWithCompletion:(void(^)(UIView *view, NSInteger index, BOOL success))completion;

@end
