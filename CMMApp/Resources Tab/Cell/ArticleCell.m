//
//  ArticleCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/7/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ArticleCell.h"
#import "Masonry.h"
#import "CMMStyles.h"

@interface ArticleCell ()

@property (strong, nonatomic) UIView *cellInfoView;

@end

@implementation ArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureArticleCell:(CMMArticle*)article {
    
    self.contentView.backgroundColor = [CMMStyles new].globalNavy;
    
    self.cellInfoView = [[UIView alloc]init];//WithFrame:CGRectMake(10, 10, (self.contentView.frame.size.width), 110)];
    [self.contentView addSubview:self.cellInfoView];
    
    self.article = article;
    
    UIView *tview = [[UIView alloc]init];//WithFrame:CGRectMake(10, 10, (self.contentView.frame.size.width), 110)];
    [self.contentView addSubview:tview];
    
    //Set article name
    self.articleName = [[UILabel alloc]init];
    self.articleName.text = self.article.title;
    self.articleName.numberOfLines = 0;
    self.articleName.textColor = [CMMStyles new].globalNavy;
    self.articleName.textAlignment = NSTextAlignmentCenter;
    [self.cellInfoView addSubview:self.articleName];
    
    self.articleImage = [[UIImageView alloc]init];
    NSURL *posterURL = [NSURL URLWithString:article.imageUrl];
    NSLog(@"POSTER URL:%@", posterURL);
    self.articleImage.image = nil;
    //UIImage *placeholder = [UIImage imageNamed:@"icon_pin"];
    [self.articleImage setImageWithURL:posterURL placeholderImage:nil];
    //self.articleImage.contentsi
    [self.cellInfoView addSubview:self.articleImage];
    
    // Autolayout for the labels
    UIEdgeInsets containerPadding = UIEdgeInsetsMake(10, 10, 5, 10);
    [self.cellInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(containerPadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(containerPadding.left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-containerPadding.bottom);
        make.right.equalTo(self.contentView.mas_right).with.offset(-containerPadding.right);
    }];
    
    [self.articleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellInfoView.mas_top);
        make.left.equalTo(self.cellInfoView.mas_left);
        make.right.equalTo(self.cellInfoView.mas_right);
        make.height.equalTo(@300);
    }];
    
    UIEdgeInsets titlePadding = UIEdgeInsetsMake(12, 5, 12, 5);
    [self.articleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleImage.mas_bottom).offset(titlePadding.top);
        make.left.equalTo(self.cellInfoView.mas_left).offset(titlePadding.left);
        make.right.equalTo(self.cellInfoView.mas_right).offset(-titlePadding.right);
        make.bottom.equalTo(self.cellInfoView.mas_bottom).with.offset(-titlePadding.bottom);
    }];
    
    self.cellInfoView.backgroundColor = [CMMStyles new].globalTan;
    self.cellInfoView.layer.cornerRadius = 10;
    self.cellInfoView.clipsToBounds = YES;
    
    //[self.cellInfoView.layer setBorderColor:[UIColor blackColor].CGColor];
    //[self.cellInfoView.layer setBorderWidth:2.0f];
}


@end
