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

@interface NewsfeedSideMenuVC () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation NewsfeedSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.categoryArray = @[@"Economics", @"Immigration", @"Healthcare", @"Another Category", @"Also this one!"];
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor blueColor];
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 55;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    cell.textLabel.text = self.categoryArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blueColor];
    NSLog(@"%@", cell.textLabel.text);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

@end
