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
    self.categoryArray = [CMMStyles getCategories];
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.table.backgroundColor = [CMMStyles getTealColor];
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 45;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.table];
    self.selectedCategories = [[NSMutableArray alloc] init];
    [self createButtons];
}

- (void)createButtons {
    
    // done button
    self.doneButton = [[UIButton alloc] init];
    [self.doneButton addTarget:self action:@selector(didPressDone) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[UIColor whiteColor]];
    [self.doneButton setTitleColor:[CMMStyles getTealColor] forState:UIControlStateNormal];
    [self.view addSubview:self.doneButton];
    UIEdgeInsets donePadding = UIEdgeInsetsMake(10, 12, 60, 12);
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.table.mas_bottom).with.offset(donePadding.top);
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
        /*for (NSString *category in self.selectedCategories) {
            if ([category isEqual:cell.textLabel.text]) {
                [self.selectedCategories removeObject:category];
            }
        }*/
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor grayColor];
        [self.selectedCategories addObject:cell.textLabel.text];
    }
    NSLog(@"%@", self.selectedCategories);
}

@end
