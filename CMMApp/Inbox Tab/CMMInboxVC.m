//
//  CMMInboxVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMInboxVC.h"

@interface CMMInboxVC ()
    
@property UISearchBar *messagesSearchBar;
@property UITableView *messagesTableView;
@property NSArray *conversations;
    
@end

@implementation CMMInboxVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSearchBar];
    [self createMessagesTableView];
    
    [self updateConstraints];
}
    
- (void)createMessagesTableView {
    self.messagesTableView = [[UITableView alloc] init];
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    
    self.messagesTableView.rowHeight = UITableViewAutomaticDimension;
    self.messagesTableView.estimatedRowHeight = 100;
    
    [self.view addSubview:self.messagesTableView];
}
    
- (void)createSearchBar {
    self.messagesSearchBar = [[UISearchBar alloc] init];
    self.messagesSearchBar.delegate = self;
    
    self.messagesSearchBar.layer.cornerRadius = 20;
    self.messagesSearchBar.clipsToBounds = YES;
    self.messagesSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self.view addSubview:self.messagesSearchBar];
}
    
- (void)updateConstraints {
    
    // Search Bar
    [self.messagesSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
        make.leading.equalTo(self.view.mas_leading);
        make.height.equalTo(@(self.messagesSearchBar.intrinsicContentSize.height));
    }];
    
    // Messages TableView
    [self.messagesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messagesSearchBar.mas_bottom);
        make.bottom.left.right.equalTo(self.messagesTableView.superview);
    }];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = [self.messagesTableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    
    if (cell == nil) {
        cell = [[ConversationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"conversationCell"];
    }
    
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
    
@end
