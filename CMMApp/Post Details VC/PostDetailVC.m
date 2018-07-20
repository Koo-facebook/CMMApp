//
//  PostDetailVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/20/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "PostDetailVC.h"
#import "CMMUser.h"
#import <DateTools.h>
#import <Masonry.h>
#import "UIImageView+AFNetworking.h"

@interface PostDetailVC ()
@end

@implementation PostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureDetails:(CMMPost *)post {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.post = post;
    self.title = @"Post Details";
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = post.topic;
    [self.view addSubview:titleLabel];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    NSLog(@"%@", titleLabel.text);
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [post.createdAt timeAgoSinceNow];
    UIColor *tealColor = [UIColor colorWithRed:54/255.f green:173/255.f blue:157/255.f alpha:1];
    dateLabel.textColor = tealColor;
    [self.view addSubview:dateLabel];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = post.category;
    categoryLabel.textColor = tealColor;
    [self.view addSubview:categoryLabel];
    [categoryLabel setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = post.detailedDescription;
    detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];
    [detailLabel setFont:[UIFont systemFontOfSize:16]];
    
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.text = post.owner.username;
    authorLabel.textColor = tealColor;
    [self.view addSubview:authorLabel];
    [authorLabel setFont:[UIFont systemFontOfSize:14]];
    
    int topPadding = 80;
    int imageSize = 70;
    CGRect imageFrame = CGRectMake(12, topPadding, imageSize, imageSize);
    UIImageView *authorImage = [[UIImageView alloc] initWithFrame:imageFrame];
    authorImage.image = nil;
    [authorImage setImageWithURL:[NSURL URLWithString:post.owner.profileImage.url] placeholderImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    authorImage.layer.cornerRadius = imageSize/2;
    authorImage.clipsToBounds = YES;
    [self.view addSubview:authorImage];
    
    // Autolayout for the labels
    
    UIEdgeInsets titlePadding = UIEdgeInsetsMake(topPadding + imageSize + 36, 12, 12, 12);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(titlePadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(titlePadding.left);
        //make.height.equalTo(@(titleLabel.intrinsicContentSize.height));
        make.right.equalTo(self.view.mas_right).with.offset(-titlePadding.right);
    }];
    UIEdgeInsets categoryPadding = UIEdgeInsetsMake(topPadding + imageSize + 12, 12, 12, 12);
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(categoryPadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(categoryPadding.left);
        make.width.equalTo(@(categoryLabel.intrinsicContentSize.width));
    }];
    UIEdgeInsets datePadding = UIEdgeInsetsMake(topPadding + imageSize + 12, 12, 12, 12);
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(datePadding.top);
        make.left.equalTo(categoryLabel.mas_right).with.offset(datePadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-datePadding.right);
    }];
    UIEdgeInsets detailPadding = UIEdgeInsetsMake(12, 12, 12, 12);
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(detailPadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(detailPadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-detailPadding.right);
        //make.height.equalTo(@(detailLabel.intrinsicContentSize.height));
    }];
    UIEdgeInsets authorPadding = UIEdgeInsetsMake(topPadding + imageSize/2, 12, 12, 12);
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(authorPadding.top);
        make.left.equalTo(authorImage.mas_right).with.offset(authorPadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-authorPadding.right);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
