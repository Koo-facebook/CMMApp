//
//  CMMTabBar.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/27/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMTabBar.h"

@implementation CMMTabBar

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *containers = [self createViewContainers];
    
    [self createCustomIcons:containers];
}

#pragma mark - private methods


- (void)createCustomIcons:(NSDictionary *)containers
{
    NSArray<CMMAnimatedBarItem *> *items = (NSArray<CMMAnimatedBarItem *> *)self.tabBar.items;
    
    int itemsCount = (int)self.tabBar.items.count - 1;
    int index = 0;
    if (items) {
        for (CMMAnimatedBarItem *item in self.tabBar.items) {
            
            NSAssert(item.image != nil, @"ICON IMAGE MISSING -- Add an icon image!");
            
            NSString *indexString = [NSString stringWithFormat:@"container%d", itemsCount-index];
            UIView *container = containers[indexString];
            container.tag = index;
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:item.image];
            icon.translatesAutoresizingMaskIntoConstraints = NO;
            icon.tintColor = [UIColor clearColor];
            
            // text
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = item.title;
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.textColor = item.textColor;
            textLabel.font = [UIFont systemFontOfSize:10.0];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            [container addSubview:icon];
            [self createConstraints:icon container:container size:item.image.size yOffset:-5];
            
            [container addSubview:textLabel];
            CGFloat textLabelWidth = self.tabBar.frame.size.width / (CGFloat)self.tabBar.items.count - 5.0;
            [self createConstraints:textLabel container:container size:CGSizeMake(textLabelWidth, 10) yOffset:16];
            
            
            item.iconView = [[CMMIconView alloc]initWithIcon:icon title:textLabel];
            
            if (0 == index) {
                [item selectedStateForItem];
            }
            
            item.image = nil;
            item.title = @"";
            index++;
        }
    }
}


- (void)createConstraints:(UIView *)view container:(UIView *)container size:(CGSize)size yOffset:(CGFloat)yOffset
{
    NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:container
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0];
    [container addConstraint:constX];
    
    NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:container
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:yOffset];
    [container addConstraint:constY];
    
    NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:size.width];
    [container addConstraint:constW];
    
    NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:size.height];
    [container addConstraint:constH];
}

- (NSDictionary *)createViewContainers
{
    NSMutableDictionary *containersDict = [NSMutableDictionary dictionary];
    if (self.tabBar.items.count> 0) {
    for (int index = 0; index < self.tabBar.items.count; index++) {
        NSLog(@"I'm inside the first container dictionary for loop");
        UIView *viewContainer = [self createViewContainer];
        
        NSString *indexStr = [NSString stringWithFormat:@"container%d", index];
        containersDict[indexStr] = viewContainer;
    }
    
    // let keys = containerDict.keys
    
    NSString *formatString = @"H:|-(0)-[container0]";
    for (int index = 1; index < self.tabBar.items.count; index++) {
        
        NSString *addFormatStr = [NSString stringWithFormat:@"-(0)-[container%d(==container0)]", index];
        formatString = [formatString stringByAppendingString:addFormatStr];
    }
    
    formatString = [formatString stringByAppendingString:@"-(0)-|"];
    NSArray<NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                                         options:NSLayoutFormatDirectionRightToLeft
                                                                                         metrics:nil
                                                                                           views:containersDict];
    [self.view addConstraints:constraints];
    }
    return containersDict;
}

- (UIView *)createViewContainer
{
    UIView *viewContainer = [[UIView alloc] init];
    viewContainer.backgroundColor = [UIColor clearColor]; // for test
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:viewContainer];
    
    // add gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGesture.numberOfTouchesRequired = 1;
    [viewContainer addGestureRecognizer:tapGesture];
    
    /*
     // add constrains
     NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:viewContainer
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeBottom
     multiplier:1
     constant:0];
     [self.view addConstraint:constY];
     
     */
    
#pragma mark:- Added a new Constraint
    //To Resolve Bug in iPhoneX Devide Added a new Bottom Constaint
    [viewContainer.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    
    
    NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:viewContainer
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:self.tabBar.frame.size.height];
    [self.view addConstraint:constH];
    return viewContainer;
}

- (void)tapHandler:(UIGestureRecognizer *)gesture
{
    NSArray<CMMAnimatedBarItem *> *items = (NSArray<CMMAnimatedBarItem *> *)self.tabBar.items;
    
    NSInteger currentIndex = gesture.view.tag;
    
    if(self.tabBarController != nil && self.tabBarController.delegate != nil && [self.tabBarController.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)] && ![self.tabBarController.delegate tabBarController:self.tabBarController shouldSelectViewController:self]) {
        return ;
    }
    
    if (self.selectedIndex != currentIndex) {
        CMMAnimatedBarItem *animationItem = items[currentIndex];
        [animationItem playAnimationForItem];
        
        CMMAnimatedBarItem *deselectItem = items[self.selectedIndex];
        [deselectItem deselectAnimationForItem];
        
        self.selectedIndex = gesture.view.tag;
        
        if (self.tabBarController != nil && self.tabBarController.delegate != nil && [self.tabBarController.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
            [self.tabBarController.delegate tabBarController:self.tabBarController didSelectViewController:self];
        }
    } else if (self.selectedIndex == currentIndex) {
        if (self.viewControllers[self.selectedIndex]) {
            if (self.viewControllers.count == 1) {
                UINavigationController *navVC = (UINavigationController *)self.viewControllers[self.selectedIndex];
                if (navVC) {
                    [navVC popToRootViewControllerAnimated:YES];
                }
            }
        }
    }
}


@end
