//
//  BubbleView.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMBubbleView.h"
#import "CMMStyles.h"

@interface CMMBubbleView()

@property (nonatomic, strong) UIColor *incomingColor;
@property (nonatomic, strong) UIColor *outgoingColor;

@end

@implementation CMMBubbleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.incoming = NO;
        self.incomingColor = [CMMStyles new].globalTan;
        self.outgoingColor = [CMMStyles new].globalNavy;
        //self.outgoingColor = [UIColor colorWithRed:22.95/255.0 green:137.7/255.0 blue:255.0/255.0 alpha:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIBezierPath *bezierPath = [UIBezierPath new];
    
    if (self.incoming) {
        [bezierPath moveToPoint:CGPointMake(22, height)];
        [bezierPath addLineToPoint:CGPointMake(width - 17, height)];
        [bezierPath addCurveToPoint:CGPointMake(width, height - 17) controlPoint1:CGPointMake(width - 7.61, height) controlPoint2:CGPointMake(width, height - 7.61)];
        [bezierPath addLineToPoint:CGPointMake(width, 17)];
        [bezierPath addCurveToPoint: CGPointMake(width - 17, 0) controlPoint1: CGPointMake(width, 7.61) controlPoint2: CGPointMake(width - 7.61, 0)];
        [bezierPath addLineToPoint:CGPointMake(21, 0)];
        [bezierPath addCurveToPoint:CGPointMake(4, 17) controlPoint1:CGPointMake(11.61, 0) controlPoint2:CGPointMake(4, 7.61)];
        [bezierPath addLineToPoint:CGPointMake(4, height - 11)];
        [bezierPath addCurveToPoint:CGPointMake(0, height) controlPoint1:CGPointMake(4, height - 1) controlPoint2:CGPointMake(0, height)];
        [bezierPath addLineToPoint:CGPointMake(-0.05, height - 0.01)];
        [bezierPath addCurveToPoint:CGPointMake(11.04, height - 4.04) controlPoint1:CGPointMake(4.07, height + 0.43) controlPoint2:CGPointMake(8.16, height - 1.06)];
        [bezierPath addCurveToPoint:CGPointMake(22, height) controlPoint1:CGPointMake(16, height) controlPoint2:CGPointMake(19, height)];
        [bezierPath closePath];
        
        [self.incomingColor setFill];
    } else {
        [bezierPath moveToPoint:CGPointMake(width - 22, height)];
        [bezierPath addLineToPoint:CGPointMake(17, height)];
        [bezierPath addCurveToPoint:CGPointMake(0, height - 17) controlPoint1:CGPointMake(7.61, height) controlPoint2:CGPointMake(0, height - 7.61)];
        [bezierPath addLineToPoint:CGPointMake(0, 17)];
        [bezierPath addCurveToPoint:CGPointMake(17, 0) controlPoint1:CGPointMake(0, 7.61) controlPoint2:CGPointMake(7.61, 0)];
        [bezierPath addLineToPoint:CGPointMake(width - 21, 0)];
        [bezierPath addCurveToPoint:CGPointMake(width - 4, height - 17) controlPoint1:CGPointMake(width - 11.61, 0) controlPoint2:CGPointMake(width - 4, 7.61)];
        [bezierPath addLineToPoint:CGPointMake(width - 4, height - 11)];
        [bezierPath addCurveToPoint:CGPointMake(width, height) controlPoint1:CGPointMake(width - 4, height - 1) controlPoint2:CGPointMake(width, height)];
        [bezierPath addLineToPoint:CGPointMake(width + 0.05, height - 0.01)];
        [bezierPath addCurveToPoint:CGPointMake(width - 11.04, height - 4.04) controlPoint1:CGPointMake(width - 4.07, height + 0.43) controlPoint2:CGPointMake(width - 8.16, height - 1.06)];
        [bezierPath addCurveToPoint:CGPointMake(width - 22, height) controlPoint1:CGPointMake(width - 16, height) controlPoint2:CGPointMake(width - 19, height)];
        
        [self.outgoingColor setFill];
    }
    
    [bezierPath closePath];
    [bezierPath fill];
}


@end
