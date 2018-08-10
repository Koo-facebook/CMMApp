//
//  PostDetailsView.m
//  CMMKit
//
//  Created by Keylonnie Miller on 8/1/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "PostDetailsView.h"

@interface PostDetailsView ()

@end

@implementation PostDetailsView

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
    UINib *nibName = [UINib nibWithNibName:@"PostDetailsView" bundle:bundle ];
    self.detailsView = [[nibName instantiateWithOwner:self options:nil] firstObject];
    
    self.detailsView.center = self.center;
    self.detailsView.autoresizingMask = UIViewAutoresizingNone;
    //CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/4, 230, 230);
    
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.layer.cornerRadius = 15;
    
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 0;
    self.categoryLabel.text = @"";
    self.postedByLabel.text = @"";
    self.timeLabel.text = @"";
    self.detailsLabel.text = @"";
    self.chatButton.titleLabel.text = @"Let's Chat!";
    self.resourcesButton.titleLabel.text = @"Tell Me More!";
    
    [self addSubview:self.detailsView];

}

-(void) layoutSubviews {
    [self layoutIfNeeded];
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.layer.cornerRadius = 35;
}

-(void)setPostWithTitle:(NSString*)title category:(NSString *)category user:(NSString *)user time:(NSString *)time description:(NSString *)description {
    self.titleLabel.text = title;
    self.categoryLabel.text = category;
    self.postedByLabel.text = ((void)("Posted By: %@"), user);
    self.timeLabel.text = time;
    self.detailsLabel.text = description;
}


-(void) didMoveToSuperview {
    //Fade in when added to SuperView
    //Then add a timer to remove the view
    self.detailsView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.15 animations:^{self.detailsView.alpha = 1.0; self.detailsView.transform = CGAffineTransformIdentity;}];
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeSelf) userInfo:nil repeats:false];
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
}


/*
 -(void) removeSelf {
 // Animate removal of view
 [UIView animateWithDuration:3 animations:^{
 self.contentView.transform = CGAffineTransformMakeScale(0.25, 0.25);
 self.contentView.alpha = 0;}
 ];
 [self removeFromSuperview];
 
 }*/

@end
