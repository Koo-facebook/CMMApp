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
#import "CMMStyles.h"

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
    self.view.backgroundColor = [CMMStyles new].globalNavy;
    
    self.navigationController.navigationBar.tintColor = [CMMStyles new].globalNavy;
    self.navigationController.navigationBar.barTintColor = [CMMStyles new].globalTan;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"articleCell"];
    //self.navigationItem.title = @"Events";
    if (!self.category){
        [[CMMResourcesAPIManager shared]getTrendingArticlesWithCompletion:^(NSArray *articles, NSError *error) {
            self.articleList = articles;
            [self.tableView reloadData];
        }];
    }
    else {
        [self fetchResourcesRelatingTo:self.category];
    }
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
    [[CMMResourcesAPIManager shared] getNewsArticlesWithTopic:[self formatForSearch:topic] fromDate:date withCompletion:^(NSArray *articles, NSError *error) {
        if (articles) {
            NSLog(@"I am fetching articles");
            if (articles.count > 0) {
                self.articleList = articles;
                [self.tableView reloadData];
            } else {
                NSMutableDictionary *entities = [CMMLanguageProcessor partsOfSpeech:[self unFormatBeforeSearch:topic]];
                NSString *searchString = @"";
                NSMutableArray *nouns = entities[@"Noun"];
                for (NSString *noun in nouns) {
                    NSString *formattedKey = [noun stringByAppendingString:@"%20"];
                    searchString = [searchString stringByAppendingString:formattedKey];
                }
                if (![searchString isEqualToString:@""]) {
                    [[CMMResourcesAPIManager shared] getNewsArticlesWithTopic:searchString fromDate:date withCompletion:^(NSArray *articles, NSError *error) {
                        self.articleList = articles;
                        [self.tableView reloadData];
                    }];
                }
            }
            
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
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (!self.category){
        [[CMMResourcesAPIManager shared]getTrendingArticlesWithCompletion:^(NSArray *articles, NSError *error) {
            self.articleList = articles;
            [self.tableView reloadData];
        }];
    }
    else {
        [self fetchResourcesRelatingTo:self.category];
    }
    //[self _playLottieAnimation];
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

- (UIImage *)resizeImageToIcon:(UIImage *)image {
    CGSize size = CGSizeMake(25, 25);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//Format post topic for searching
- (NSString *)formatForSearch: (NSString *)topic{
    NSString *categoryNoSpaces = [topic stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *finalCategory = [categoryNoSpaces stringByReplacingOccurrencesOfString:@" ' " withString:@"%27"];
    
    NSLog(@"CATEGORY FOR SEARCH: %@", finalCategory);
    
    return finalCategory;
}

- (NSString *)unFormatBeforeSearch: (NSString *)formattedTopic {
    NSString *categoryWithSpaces = [[formattedTopic stringByReplacingOccurrencesOfString:@"%20" withString:@" "] stringByReplacingOccurrencesOfString:@"%27" withString:@" ' "];
    return categoryWithSpaces;
}

@end
