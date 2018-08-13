//
//  AboutViewCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "AboutViewCell.h"
#import "Masonry.h"

@interface AboutViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation AboutViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.superview.mas_top).offset(25);
            make.bottom.equalTo(self.titleLabel.superview.mas_bottom).offset(-15);
            make.left.equalTo(self.titleLabel.superview.mas_left).offset(15);
            make.right.equalTo(self.titleLabel.superview.mas_right).offset(-15);
        }];
        
    }
    return self;
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
