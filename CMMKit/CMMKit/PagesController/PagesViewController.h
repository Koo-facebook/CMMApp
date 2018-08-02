//
//  PagesViewController.h
//  CMMKit
//
//  Created by Keylonnie Miller on 7/31/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagesViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (void)setUpPagesWithText: (NSArray<NSString*> *)text withImages: (NSArray *)images;

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageText;
@property (strong, nonatomic) NSArray *pageImage;
@property (strong, nonatomic) UIButton *button;



@end
