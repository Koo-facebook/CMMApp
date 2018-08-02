//
//  PagesViewController.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/31/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "PagesViewController.h"
#import "PagesContentViewController.h"

@interface PagesViewController ()

@property (nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic) CALayer *imageLayer;
@end

@implementation PagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.button = [[UIButton alloc]init];
    self.button.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:self.button];
    
}

- (void)setUpPagesWithText: (NSArray *)text withImages: (NSArray *)images {
    // tests display on each page
    self.pageText = text;
    (NSLog(@"Text Pulled: %@", self.pageText));
    // images display on each page
   // self.pageImage = images;
    
    [self setUpImages];
    [self completePageControllerSetUp];
}

- (void) setUpImages {
    //create first layer
    self.imageLayer = [CALayer layer];
    self.imageLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-46);
    self.imageLayer.contents =(__bridge id _Nullable)(([UIImage imageNamed:self.pageImage[0]].CGImage));
    self.imageLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    //create dim layer for easy to read text with white color
    CALayer *dimLayer = [CALayer layer];
    dimLayer.frame = self.imageLayer.frame;
    dimLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    
    [self.view.layer addSublayer:self.imageLayer];
    [self.view.layer addSublayer:dimLayer];
}

-(void)completePageControllerSetUp {
    // page view controller configuration
    self.pageController = [[UIPageViewController alloc]init];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    PagesContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    //NSLog(@"View Controllers: %@",startingViewController);
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    self.pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.pageController.view.backgroundColor = [UIColor redColor];
    //[self addChildViewController:self.pageController];
    //[self.view addSubview:self.pageController.view];
    //[self.pageController didMoveToParentViewController:self];
    
    // page indicator configuration
    self.pageControl.numberOfPages = [self.pageText count];
    
    // make views visible to bring views to front
    //[self.pageController bringSubviewToFront:self.pageControl];
    //[self.pageController bringSubviewToFront:self.button];
}

- (PagesContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ([self.pageText count]==0 || index >= [self.pageText count]) {
        return nil;
    }
    
    PagesContentViewController *pageContent = [[PagesContentViewController alloc]init];
    
    pageContent.text = self.pageText[index];
    pageContent.pageIndex = index;
    return pageContent;
}


#pragma mark - Page View Controller Delegate
- (void)pageViewController:(nonnull UIPageViewController *)pageViewController willTransitionToViewControllers:(nonnull NSArray<UIViewController *> *)pendingViewControllers
{
    NSUInteger pageIndex =((PagesContentViewController *)(pendingViewControllers.firstObject)).pageIndex;
    self.currentIndex = pageIndex;
}


#pragma mark - Page View Controller Data Source
-(UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController{
    NSUInteger index = ((PagesContentViewController*)viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.pageText count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController{
    NSUInteger index = ((PagesContentViewController*)viewController).pageIndex;
    
    if (index == 0 || index==NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


@end
