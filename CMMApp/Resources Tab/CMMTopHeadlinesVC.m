//
//  CMMTopHeadlinesVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 8/7/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMTopHeadlinesVC.h"
#import "ArticleCell.h"
#import "CMMWebVC.h"

@interface CMMTopHeadlinesVC ()

@property (strong, nonatomic) NSArray *articleList;

@end

@implementation CMMTopHeadlinesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Top Headlines";
    [self createTableView];
    [self createPullToRefresh];
    
    self.articleList = [[NSArray alloc]init];
    //Navigation Bar Set-up
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.navigationItem.title = @"Events";
    if (!self.category){
        self.category = @"Trump";
    }
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"articleCell"];
    [self fetchResourcesRelatingTo:self.category];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//NETWORK REQUEST
-(void) fetchResourcesRelatingTo: (NSString *)topic {
    NSDate *today = [NSDate date];
    NSDate *twoWeeksAgo = [today dateByAddingTimeInterval:-14*24*60*60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-dd-MM"];
    NSString *date = [formatter stringFromDate:twoWeeksAgo];
    // NSString *date = [NSDateFormatter datefrom]
    [[CMMResourcesAPIManager shared] getNewsArticlesWithTopic:topic fromDate:date withCompletion:^(NSArray *articles, NSError *error) {
        if (articles) {
            NSLog(@"I am fetching articles");
            self.articleList = articles;
            for(CMMArticle *article in articles) {
                NSString *name = article.title;
                NSLog(@"%@", name);
                //                [[CMMEventAPIManager shared] pullVenues:event.venue_id withCompletion:^(NSDictionary *venues, NSError *error) {
                //                    NSNumber *latitude = venues[@"latitude"];
                //                    NSNumber *longitude = venues [@"longitude"];
                //                    //NSLog(@"Latitude: %@", latitude);
                //                    //NSLog(@"Longitude: %@", longitude);
                //                    CLLocationCoordinate2D venueLocation = CLLocationCoordinate2DMake(latitude.floatValue,longitude.floatValue);
                //                    [self addingPins:venueLocation withSubTitle: event.title];
            }
            NSLog(@"😎😎😎 Successfully loaded events table");
            [self.tableView reloadData];
        }
        else {
            NSLog(@"😫😫😫 Error getting events: %@", error.localizedDescription);
        }
    }];
}

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.rowHeight = 150;
    
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"articleCell"];
    cell.article = self.articleList[indexPath.row];
    [cell configureArticleCell:cell.article];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMWebVC *webViewController = [[CMMWebVC alloc]init];
    webViewController.article = self.articleList[indexPath.row];
    UINavigationController *webNav = [[UINavigationController alloc]initWithRootViewController:webViewController];
    [self presentViewController:webNav animated:YES completion:^{
    }];
}

-(void)createPullToRefresh {
    //Initialize pull down to refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    //Customize Refresh Control
    refreshControl.backgroundColor = [UIColor clearColor];
    refreshControl.tintColor = [UIColor clearColor];
    
    //Linking pull down action to refresh control
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    //Adding refresh information to the tableview
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchResourcesRelatingTo:self.category];
    //[self _playLottieAnimation];
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}


@end
