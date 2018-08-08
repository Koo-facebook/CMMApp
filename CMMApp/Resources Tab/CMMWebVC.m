//
//  CMMWebVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/7/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMWebVC.h"

@interface CMMWebVC () <UIWebViewDelegate>

@end

@implementation CMMWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWebkit];
    [self createBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createWebkit {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSURL *url = self.article.url;
    NSLog(@"WEB URL: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    [webView loadRequest:request];
    [webView canGoBack];
    webView.delegate = self;
    [self.view addSubview:webView];
}

-(void)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissWebVC)];
    self.navigationItem.leftBarButtonItem = backButton;

}

-(void)dismissWebVC {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
