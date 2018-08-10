//
//  CMMBadge.m
//  CMMKit
//
//  Created by Keylonnie Miller on 8/9/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMBadge.h"
#import "Masonry.h"

@implementation CMMBadge

+(CMMBadge *)badge {
    return [[CMMBadge alloc] initWithFrame:CGRectMake(0,0,18,18)];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.backgroundColor = [UIColor redColor].CGColor;
        self.layer.cornerRadius = frame.size.width / 2;
        
        [self configureNumberLabel];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self createSizeConstraints:frame.size];
    }
    return self;    
}

- (void)createSizeConstraints:(CGSize)size
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:size.width];
    [self addConstraint:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1
                                                                         constant:size.height];
    [self addConstraint:heightConstraint];
}

-(void)configureNumberLabel {
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:13.0];
    self.textColor = [UIColor whiteColor];
}

-(void)addBadgeToTabItemView: (UIView *)view {
    [self addSubview:self.numberLabel];
    [view addSubview:self];
    
    // create constraints
    self.topConstraint = [NSLayoutConstraint constraintWithItem:self
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:view
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:3];
    if (self.topConstraint) {
        [view addConstraint:self.topConstraint];
    }
    
    self.centerXConstraint = [NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:10];
    if (self.centerXConstraint) {
        [view addConstraint:self.centerXConstraint];
    }
}


@end
