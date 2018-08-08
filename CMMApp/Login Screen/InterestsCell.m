//
//  InterestsCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "InterestsCell.h"
#import "Masonry.h"

@implementation InterestsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureInterestsCell:(NSString *)cellTitle {
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 0;
    self.title.textColor = [UIColor blackColor];
    self.title.text = cellTitle;
    [self.contentView addSubview:self.title];
    [self.title setFont:[UIFont systemFontOfSize:16]];
    
    UIEdgeInsets containerPadding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(containerPadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(containerPadding.left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-containerPadding.bottom);
        make.right.equalTo(self.contentView.mas_right).with.offset(-containerPadding.right);
    }];
    
    //self.backgroundColor = [UIColor blueColor];
}
@end
