//
//  PostDetailsView.m
//  CMMKit
//
//  Created by Keylonnie Miller on 8/1/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "PostDetailsView.h"
#import "Masonry.h"

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
    
    self.detailsView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:235/255.0 blue:233/255.0 alpha:1.0];
    self.detailsView.layer.borderColor = [[UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0] CGColor];
    self.detailsView.layer.borderWidth = 0.5;
    self.detailsView.center = self.center;
    self.detailsView.autoresizingMask = UIViewAutoresizingNone;
    self.detailsView.backgroundColor = [UIColor colorWithRed:(CGFloat)(239.0/255.0) green:(CGFloat)(235.0/255.0) blue:(CGFloat)(233.0/255.0) alpha:1];
    //CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/4, 230, 230);
    
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.layer.cornerRadius = 15;
    
    self.titleLabel.text = @"";
    self.titleLabel.textColor = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0];
    self.titleLabel.numberOfLines = 3;
    self.categoryLabel.text = @"";
    self.categoryLabel.textColor = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0];
    self.postedByLabel.text = @"";
    self.postedByLabel.textColor = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0];
    self.timeLabel.text = @"";
    self.timeLabel.textColor = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0];
    self.detailsLabel.text = @"";
    self.detailsLabel.textColor = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0];
    self.detailsLabel.numberOfLines = 0;
    
    self.userImage.image = [UIImage imageNamed:@"placeholderProfileImage"];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
    self.userImage.clipsToBounds = YES;
    
    self.usernameLabel.text = @"";
    //self.chatButton.titleLabel.text = @"Let's Chat!";
    //self.resourcesButton.titleLabel.text = @"Tell Me More!";
    self.reportLabel.text = @"Report";
    
    
    [self addSubview:self.detailsView];
    
}

-(void) layoutSubviews {
    [self layoutIfNeeded];
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.layer.cornerRadius = 35;
}

-(void)setPostWithTitle:(NSString*)title category:(NSString *)category user:(NSString *)user time:(NSString *)time description:(NSString *)description showingChatButton: (BOOL) chatButtonView {
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor colorWithRed:(CGFloat)(46.0/255.0) green:(CGFloat)(64.0/255.0) blue:(CGFloat)(87.0/255.0) alpha:1];
    self.usernameLabel.text = user;
    self.categoryLabel.text = category;
    self.postedByLabel.text = ((void)("Posted By: %@"), user);
    self.timeLabel.text = time;
    self.detailsLabel.text = description;
    
    int resourceLeftPadding;
    if (chatButtonView == YES) {
        self.chatButton = [[UIButton alloc] init];
        // [self.chatButton addTarget:self action:@selector(didPressChat) forControlEvents:UIControlEventTouchUpInside];
        [self.chatButton setTitle:@"Let's Chat!" forState:UIControlStateNormal];
        self.chatButton.layer.cornerRadius = 6;
        self.chatButton.clipsToBounds = YES;
        [self.chatButton setBackgroundColor:[UIColor colorWithRed:46/255.0 green:64/255.0 blue:87/255.0 alpha:1.0]];
        [self.chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.detailsView addSubview:self.chatButton];
        UIEdgeInsets chatPadding = UIEdgeInsetsMake(15, 12, 12, self.detailsView.frame.size.width/2 + 6);
        [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom).with.offset(chatPadding.top);
            make.left.equalTo(self.detailsView.mas_left).with.offset(chatPadding.left);
            make.right.equalTo(self.detailsView.mas_right).with.offset(-chatPadding.right);
        }];
        resourceLeftPadding = self.detailsView.frame.size.width/2 + 6;
    } else {
        resourceLeftPadding = 12;
    }
    
    // resources button
    self.resourcesButton = [[UIButton alloc] init];
    // [self.resourcesButton addTarget:self action:@selector(didPressResources) forControlEvents:UIControlEventTouchUpInside];
    self.resourcesButton.layer.cornerRadius = 6;
    self.resourcesButton.clipsToBounds = YES;
    [self.resourcesButton setTitle:@"Tell Me More!" forState:UIControlStateNormal];
    [self.resourcesButton setBackgroundColor:[UIColor colorWithRed:167/255.0 green:173/255.0 blue:186/255.0 alpha:1.0]];
    [self.resourcesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.detailsView addSubview:self.resourcesButton];
    UIEdgeInsets resourcePadding = UIEdgeInsetsMake(15, resourceLeftPadding, 12, 12);
    [self.resourcesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).with.offset(resourcePadding.top);
        make.left.equalTo(self.detailsView.mas_left).with.offset(resourcePadding.left);
        make.right.equalTo(self.detailsView.mas_right).with.offset(-resourcePadding.right);
    }];
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
