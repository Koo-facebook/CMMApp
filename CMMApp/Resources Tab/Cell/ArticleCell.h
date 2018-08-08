//
//  ArticleCell.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/7/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMArticle.h"
#import "UIImageView+AFNetworking.h"


@interface ArticleCell : UITableViewCell

@property (strong, nonatomic) CMMArticle *article;
@property (strong, nonatomic) UILabel *articleName;
@property (strong, nonatomic) UIImageView *articleImage;

- (void)configureArticleCell:(CMMArticle*)article;

@end
