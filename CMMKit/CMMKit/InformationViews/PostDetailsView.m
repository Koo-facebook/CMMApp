//
//  PostDetailsView.m
//  CMMKit
//
//  Created by Keylonnie Miller on 8/1/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "PostDetailsView.h"

@interface PostDetailsView ()

@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurredView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *resourcesButton;

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
    self.contentView = [[nibName instantiateWithOwner:self options:nil] firstObject];
    
    self.contentView.center = self.center;
    self.contentView.autoresizingMask = UIViewAutoresizingNone;
    //CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/4, 230, 230);
    self.contentView.frame = self.bounds;
    
    self.blurredView.frame = self.frame;
    
    self.titleLabel.text = @"";
    self.categoryLabel.text = @"";
    self.postedByLabel.text = @"";
    self.timeLabel.text = @"";
    self.detailsLabel.text = @"";
    self.chatButton.titleLabel.text = @"Let's Chat!";
    self.resourcesButton.titleLabel.text = @"Tell Me More!";
    
    [self addSubview:self.blurredView];
    //[self addSubview:self.blurredView];
    [self addSubview:self.contentView];
    // [self.contentView addSubview:self.detailsView];
    // [self.contentView addSubview:self.scrollView];
}

-(void) layoutSubviews {
    [self layoutIfNeeded];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 35;
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
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.15 animations:^{self.contentView.alpha = 1.0; self.contentView.transform = CGAffineTransformIdentity;}];
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeSelf) userInfo:nil repeats:false];
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
