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
    
    CGRect categoryHeaderFrame = CGRectMake(15, 36, 2*self.view.frame.size.width/3 - 30, 30);
    UILabel *categoryHeader = [[UILabel alloc] initWithFrame:categoryHeaderFrame];
    categoryHeader.text = @"Pick your categories";
    categoryHeader.textColor = [UIColor whiteColor];
    categoryHeader.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightBold];
    [self.view addSubview:categoryHeader];
    
    CGRect tableViewFrame = CGRectMake(0, 70, 2*self.view.frame.size.width/3, 240);
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.table.backgroundColor = [CMMStyles getTealColor];
    self.table.rowHeight = 30;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.table];
    self.selectedCategories = [[NSMutableArray alloc] init];
    
    CGRect sortHeaderFrame = CGRectMake(15, 340, 2*self.view.frame.size.width/3 - 30, 30);
    UILabel *sortHeader = [[UILabel alloc] initWithFrame:sortHeaderFrame];
    sortHeader.text = @"Sort by...";
    sortHeader.textColor = [UIColor whiteColor];
    sortHeader.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightBold];
    [self.view addSubview:sortHeader];
    
    CGRect recentButtonFrame = CGRectMake(15, 370, 2*self.view.frame.size.width/3 - 30, 30);
    UIButton *recentButton = [[UIButton alloc] initWithFrame:recentButtonFrame];
    [recentButton setTitle:@"Most Recent" forState:UIControlStateNormal];
    recentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recentButton.titleLabel.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightLight];
    [self.view addSubview:recentButton];
    
    CGRect trendingButtonFrame = CGRectMake(15, 400, 2*self.view.frame.size.width/3 - 30, 30);
    UIButton *trendingButton = [[UIButton alloc] initWithFrame:trendingButtonFrame];
    [trendingButton setTitle:@"Trending" forState:UIControlStateNormal];
    trendingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [trendingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    trendingButton.titleLabel.font = [CMMStyles getFontWithSize:14 Weight:UIFontWeightLight];
    [self.view addSubview:trendingButton];
}

- (void)createButtons {
    
    // done button
    self.doneButton = [[UIButton alloc] init];
    [self.doneButton addTarget:self action:@selector(didPressDone) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton setTitleColor:[CMMStyles getTealColor] forState:UIControlStateNormal];
    [self.view addSubview:self.doneButton];
    UIEdgeInsets donePadding = UIEdgeInsetsMake(0, 12, 60, 12);
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(donePadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-donePadding.right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-donePadding.bottom);
    }];
}

- (void)didPressDone {
    [self.delegate reloadCategories:self.selectedCategories];
    [self.sideMenuController hideRightViewAnimated];
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
        cell.textLabel.textColor = [UIColor grayColor];
        [self.selectedCategories addObject:cell.textLabel.text];
    }
}

@end
