//
//  CMMPopUp.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/26/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "CMMPopUp.h"

@interface CMMPopUp ()



@end

@implementation CMMPopUp

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
   NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    UINib *nibName = [UINib nibWithNibName:@"CMMPopUpView" bundle:bundle ];
    self.contentView = [[nibName instantiateWithOwner:self options:nil] firstObject];

    self.contentView.center = self.center;
    self.contentView.autoresizingMask = UIViewAutoresizingNone;
    //CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/4, 230, 230);
    self.contentView.frame = self.bounds;
    
    self.headlineLabel.text = @"";
    self.subheadLabel.text = @"";
    
    [self addSubview:self.contentView];
}

-(void) layoutSubviews {
    [self layoutIfNeeded];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 15;
}

-(void)setImage:(UIImage *)image {
    self.statusImage.image = image;
}

-(void) didMoveToSuperview {
    //Fade in when added to SuperView
    //Then add a timer to remove the view
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.15 animations:^{self.contentView.alpha = 1.0; self.contentView.transform = CGAffineTransformIdentity;}];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeSelf) userInfo:nil repeats:false];
}

-(void) removeSelf {
    // Animate removal of view
    [UIView animateWithDuration:2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        self.contentView.alpha = 0;}
     ];
    [self removeFromSuperview];
    
}

@end
