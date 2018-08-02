//
//  PagesContentViewController.m
//  CMMKit
//
//  Created by Keylonnie Miller on 7/31/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "PagesContentViewController.h"

@interface PagesContentViewController ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation PagesContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[UITextView alloc]init];
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.text = self.text;
    [self.view addSubview:self.textView];
    
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
