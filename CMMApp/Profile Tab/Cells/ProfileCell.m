//
//  ProfileCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ProfileCell.h"

@interface ProfileCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ProfileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    return self;
}
         
-(void)configureProfileCell:(CMMUser *)user {
    self.userInterests = user[@"interests"];
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    NSLog(@"USER INTERESTS: %@", self.userInterests[0]);
    self.titleLabel.text = self.title;
    [self addSubview:self.titleLabel];
 }

- (void)prepareForReuse
{
    self.title = nil;
    self.textColor = nil;
    [super prepareForReuse];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.titleLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}

@end
