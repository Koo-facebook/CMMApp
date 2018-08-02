//
//  NewsfeedSideMenuVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/23/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "NewsfeedSideMenuVC.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "CMMStyles.h"
#import <Masonry.h>
#import "CMMNewsfeedVC.h"

@interface NewsfeedSideMenuVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIButton *doneButton;
//@property (strong, nonatomic) UIButton *cancelButton;
@property (assign, nonatomic) int labelHeight;
@property (assign, nonatomic) int topBuffer;
@property (assign, nonatomic) int sideBuffer;
@property (assign, nonatomic) int middleBuffer;
@property (strong, nonatomic) UIButton *recentButton;
@property (strong, nonatomic) UIButton *trendingButton;
@end

@implementation NewsfeedSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CMMStyles getTealColor];
    [self createMenu];
    [self createButtons];
}

- (void)createMenu {
    self.categoryArray = [CMMStyles getCategories];
    self.labelHeight = 30;
    self.topBuffer = 40;
    self.sideBuffer = 15;
    self.middleBuffer = 50;
    
    CGRect categoryHeaderFrame = CGRectMake(self.sideBuffer, self.topBuffer, 2*self.view.frame.size.width/3 - 2*self.sideBuffer, self.labelHeight);
    UILabel *categoryHeader = [[UILabel alloc] initWithFrame:categoryHeaderFrame];
    categoryHeader.text = @"Pick your categories";
    categoryHeader.textColor = [UIColor whiteColor];
    categoryHeader.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightBold];
    [self.view addSubview:categoryHeader];
    
    CGRect tableViewFrame = CGRectMake(0, self.topBuffer + self.labelHeight, 2*self.view.frame.size.width/3, self.labelHeight * self.categoryArray.count);
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.table.backgroundColor = [CMMStyles getTealColor];
    self.table.rowHeight = 30;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.table];
    self.selectedCategories = [[NSMutableArray alloc] init];
    
    CGRect sortHeaderFrame = CGRectMake(self.sideBuffer, self.topBuffer + self.labelHeight*(self.categoryArray.count) + self.middleBuffer, 2*self.view.frame.size.width/3 - 2 * self.sideBuffer, self.labelHeight);
    UILabel *sortHeader = [[UILabel alloc] initWithFrame:sortHeaderFrame];
    sortHeader.text = @"Sort by...";
    sortHeader.textColor = [UIColor whiteColor];
    sortHeader.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightBold];
    [self.view addSubview:sortHeader];
}

- (void)createButtons {
    
    // done button
    CGRect doneButtonFrame = CGRectMake(self.sideBuffer, self.view.frame.size.height - 60 - self.labelHeight, 2*self.view.frame.size.width/3 - 2*self.sideBuffer, self.labelHeight);
    self.doneButton = [[UIButton alloc] initWithFrame:doneButtonFrame];
    [self.doneButton addTarget:self action:@selector(didPressDone) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton setTitleColor:[CMMStyles getTealColor] forState:UIControlStateNormal];
    [self.view addSubview:self.doneButton];
    
    CGRect recentButtonFrame = CGRectMake(self.sideBuffer, self.topBuffer + self.labelHeight*(self.categoryArray.count + 1) + self.middleBuffer, 2*self.view.frame.size.width/3 - 2*self.sideBuffer, self.labelHeight);
    self.recentButton = [[UIButton alloc] initWithFrame:recentButtonFrame];
    [self.recentButton setTitle:@"Most Recent" forState:UIControlStateNormal];
    self.recentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.recentButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    self.recentButton.titleLabel.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightLight];
    self.recentButton.selected = !self.sortByTrending;
    [self.recentButton addTarget:self action:@selector(didPressRecent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recentButton];
    
    CGRect trendingButtonFrame = CGRectMake(self.sideBuffer, self.topBuffer + self.labelHeight*(self.categoryArray.count + 2) + self.middleBuffer, 2*self.view.frame.size.width/3 - 2*self.sideBuffer, self.labelHeight);
    self.trendingButton = [[UIButton alloc] initWithFrame:trendingButtonFrame];
    [self.trendingButton setTitle:@"Trending" forState:UIControlStateNormal];
    self.trendingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.trendingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.trendingButton.titleLabel.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightLight];
    self.trendingButton.selected = self.sortByTrending;
    [self.trendingButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.trendingButton addTarget:self action:@selector(didPressTrending) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.trendingButton];
}

- (void)didPressDone {
    [self.delegate reloadNewsfeedWithCategories:self.selectedCategories Trending:self.sortByTrending];
    [self.sideMenuController hideRightViewAnimated];
}

- (void)didPressRecent {
    self.recentButton.selected = YES;
    self.trendingButton.selected = NO;
    self.sortByTrending = NO;
}

- (void)didPressTrending {
    self.recentButton.selected = NO;
    self.trendingButton.selected = YES;
    self.sortByTrending = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    cell.textLabel.text = self.categoryArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightLight];
    cell.backgroundColor = [CMMStyles getTealColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        [self.selectedCategories removeObject:cell.textLabel.text];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor blueColor];
        [self.selectedCategories addObject:cell.textLabel.text];
    }
}

@end
