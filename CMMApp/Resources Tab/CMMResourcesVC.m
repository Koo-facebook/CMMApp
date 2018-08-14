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
#import "CMMResourcesAPIManager.h"
#import "CMMArticle.h"
#import "CMMStyles.h"
#import "CMMTopHeadlinesVC.h"

@interface CMMResourcesVC ()

@property (strong, nonatomic) NSArray *topicList;
@property (strong, nonatomic) NSArray *articles;
@end

@implementation CMMResourcesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topicList = [[NSArray alloc]init];
    self.topicList = @[@"Social Issues",@"Education", @"Criminal Issues", @"Economics", @"Elections", @"Environment", @"Foreign Policy", @"Healthcare", @"Immigration", @"National Security"];
    //self.articles = [[NSArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Resources";
    //[self fetchResourcesRelatingTo:@"Donald Trump"];

    // Create properties
    [self createSearchBar];
    //[self createCoverImage];
    //[self createLabel];
    [self createCollectionView];
    //[self createScrollView];
    [self createTapGestureRecognizer:@selector(wholeViewTapped)];
    //Fix Layout
    [self updateConstraints];
}

//Layout of VC
-(void) updateConstraints {
    // Search Bar
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication.statusBarFrame.size.height));
        make.centerX.equalTo(self.searchBar.superview.mas_centerX);
        make.width.equalTo(self.searchBar.superview.mas_width);
        make.height.equalTo(@(50));
    }];
//    // Cover Image
//    [self.topicCoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.searchBar.mas_bottom).offset(15);
//        make.centerX.equalTo(self.topicCoverImage.superview.mas_centerX);
//        make.height.equalTo(@(self.topicCoverImage.superview.frame.size.height/2.75));
//        make.width.equalTo(@(self.topicCoverImage.superview.frame.size.width/1.15));
//    }];
//
//    // Category Label (in Image)
//    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.topicCoverImage.mas_bottom);
//        make.left.equalTo(self.topicCoverImage.mas_leftMargin);
//        make.width.equalTo(@(self.categoryLabel.intrinsicContentSize.width));
//        make.height.equalTo(@(self.categoryLabel.intrinsicContentSize.height));
//    }];
    
//    // Scroll View
//    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topicsCollectionView.mas_top);
//        //make.centerX.equalTo(self.scroll.superview.mas_centerX);
//        make.height.equalTo(@(self.topicsCollectionView.frame.size.height));
//        make.width.equalTo(@(self.topicsCollectionView.frame.size.width));
//    }];
//
    // Collection View
    [self.topicsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(10);
        make.centerX.equalTo(self.topicsCollectionView.superview.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
       // make.width.equalTo(@(self.topicsCollectionView.superview.frame.size.width-20));
        //make.height.equalTo(@(226.8));
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = self.searchBar.text;
    [self moveToHeadLinesVC:searchText];
}

//Create CollectionView
- (void) createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.topicsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.topicsCollectionView.delegate = self;
    self.topicsCollectionView.dataSource = self;
    [self.topicsCollectionView registerClass:[TopicsCollectionCell class] forCellWithReuseIdentifier:@"topicCell"];
    self.topicsCollectionView.backgroundColor = [UIColor whiteColor];
    self.topicsCollectionView.userInteractionEnabled = YES;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //layout.minimumLineSpacing = 5;
    //layout.minimumInteritemSpacing = 5;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = ((self.topicsCollectionView.frame.size.width-20) - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
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
    [cell configureCollectionCell:self.topicList[indexPath.item]];

    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topicList.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self moveToHeadLinesVC:self.topicList[indexPath.item]];
    //[self presentViewController:resourcesVC animated:YES completion:^{}];
}

-(void)moveToHeadLinesVC: (NSString *)category {
    CMMTopHeadlinesVC *resourcesVC = [[CMMTopHeadlinesVC alloc]init];
    UINavigationController *resourcesNavigation = [[UINavigationController alloc]initWithRootViewController:resourcesVC];
    NSLog(@"We are in selected collection view cell");
    resourcesVC.category = category;
    [self.navigationController pushViewController:resourcesVC animated:YES];
}

// Make keyboard disappear action
- (void)wholeViewTapped {
    [self.view endEditing:YES];
}

// Creates Generic TapGestureRecognizer
- (void)createTapGestureRecognizer:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}
@end
