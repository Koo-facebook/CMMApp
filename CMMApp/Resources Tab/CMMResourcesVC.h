//
//  CMMResourcesVC.h
//  CMMApp
//
//  Created by Keylonnie Miller on 7/25/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourcesVC : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *topicsCollectionView;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIImageView *topicCoverImage;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UILabel *categoryLabel;

@end
