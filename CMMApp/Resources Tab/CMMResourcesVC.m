//
//  CMMResourcesVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/25/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//


#import "CMMResourcesVC.h"
#import "TopicsCollectionCell.h"
#import "Masonry.h"
#import "Parse.h"
#import "ParseUI.h"
@interface ResourcesVC ()

@property (strong, nonatomic) NSArray *topicList;
@end

@implementation ResourcesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topicList = [[NSArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Resources";
    
    // Create properties
    [self createSearchBar];
    [self createCoverImage];
    [self createLabel];
    [self createCollectionView];
    [self createScrollView];
    [self createTapGestureRecognizer:@selector(wholeViewTapped)];
    //Fix Layout
    [self updateConstraints];
}

//Layout of VC
-(void) updateConstraints {
    // Search Bar
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.superview.mas_top).offset(90);
        make.centerX.equalTo(self.searchBar.superview.mas_centerX);
        make.width.equalTo(self.searchBar.superview.mas_width);
        make.height.equalTo(@(50));
    }];
    // Cover Image
    [self.topicCoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(15);
        make.centerX.equalTo(self.topicCoverImage.superview.mas_centerX);
        make.height.equalTo(@(325));
        make.width.equalTo(@(336));
    }];
    
    // Category Label (in Image)
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topicCoverImage.mas_bottom);
        make.left.equalTo(self.topicCoverImage.mas_leftMargin);
        make.width.equalTo(@(self.categoryLabel.intrinsicContentSize.width));
        make.height.equalTo(@(self.categoryLabel.intrinsicContentSize.height));
    }];
    
    // Scroll View
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicsCollectionView.mas_top);
        //make.centerX.equalTo(self.scroll.superview.mas_centerX);
        make.height.equalTo(@(self.topicsCollectionView.frame.size.height));
        make.width.equalTo(@(self.topicsCollectionView.frame.size.width));
    }];
    
    // Collection View
    [self.topicsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicCoverImage.mas_bottom).offset(15);
        make.left.equalTo(self.topicCoverImage.mas_left);
        //make.bottom.equalTo(self.topicsCollectionView.superview.mas_bottom);
        make.width.equalTo(@(336));
        make.height.equalTo(@(226.8));
    }];
}
//Create Search Bar
-(void) createSearchBar {
    CGRect searchFrame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search a topic...";
    [self.view addSubview:self.searchBar];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

//Create UIImage (Focus Category)
-(void) createCoverImage {
    self.topicCoverImage = [[UIImageView alloc]init];
    self.topicCoverImage.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topicCoverImage];
}

// Create Label to go ontop of Image
-(void) createLabel {
    self.categoryLabel = [[UILabel alloc]init];
    self.categoryLabel.font = [UIFont fontWithName:@"Arial" size:20];
    self.categoryLabel.numberOfLines = 2;
    self.categoryLabel.textColor = [UIColor whiteColor];
    self.categoryLabel.text = @"Environmental";
    [self.topicCoverImage addSubview:self.categoryLabel];
}

//Create CollectionView
- (void) createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.topicsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.topicsCollectionView.delegate = self;
    self.topicsCollectionView.dataSource = self;
    [self.topicsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"topicCell"];
    self.topicsCollectionView.backgroundColor = [UIColor blueColor];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 3;
    
    CGFloat itemWidth = 168;
    CGFloat itemHeight = itemWidth * 1.35;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.view addSubview:self.topicsCollectionView];
}

//Create Scroll
-(void)createScrollView {
    self.scroll = [[UIScrollView alloc]init];
    self.scroll.delegate = self;
    self.scroll.showsVerticalScrollIndicator=NO;
    self.scroll.showsHorizontalScrollIndicator = YES;
    self.scroll.scrollEnabled=YES;
    self.scroll.userInteractionEnabled=YES;
    [self.topicsCollectionView addSubview:self.scroll];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TopicsCollectionCell *cell = [self.topicsCollectionView dequeueReusableCellWithReuseIdentifier:@"topicCell" forIndexPath:indexPath];
    //[self.topicsCollectionView registerClass:[TopicsCollectionCell class] forCellReuseIdentifier:@"topicCell"];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

// Make keyboard disappear action
- (void)wholeViewTapped {
    [self.view endEditing:YES];
}

// Creates Generic TapGestureRecognizer
- (void)createTapGestureRecognizer:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [self.view addGestureRecognizer:tapGesture];
}
@end
