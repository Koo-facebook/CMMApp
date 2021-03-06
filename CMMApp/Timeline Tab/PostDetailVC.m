//
//  PostDetailVC.m
//  CMMApp
//
//  Created by Olivia Jorasch on 7/20/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "PostDetailVC.h"
#import "CMMUser.h"
#import <DateTools.h>
#import <Masonry.h>
#import "UIImageView+AFNetworking.h"
#import "CMMConversation.h"
#import "CMMChatVC.h"
#import "CMMStyles.h"
#import "CMMTopHeadlinesVC.h"

@interface PostDetailVC ()

@end

@implementation PostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CMMStyles new].globalTan;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureDetails:(CMMPost *)post {
    self.post = post;
    self.title = @"Post Details";
    
    int topPadding = 80;
    int imageSize = 70;
    
    [self createLabels];
    [self displayProfileImageWithSize:imageSize padding:topPadding];
    [self layOutLabelsWithImageSize:imageSize padding:topPadding];
    [self createButtons];
}

- (void)configureLabel:(UILabel *)label text:(NSString *)text fontSize:(CGFloat)fontSize {
    label.text = text;
    [self.view addSubview:label];
    [label setFont:[CMMStyles getTextFontWithSize:fontSize]];
}

- (void)createLabels {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [CMMStyles new].globalNavy;
    [self configureLabel:self.titleLabel text:self.post.topic fontSize:16];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [CMMStyles new].globalNavy;
    [self configureLabel:self.dateLabel text:[self.post.createdAt timeAgoSinceNow] fontSize:14];
    
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.textColor = [CMMStyles new].globalNavy;
    [self configureLabel:self.categoryLabel text:self.post.category fontSize:14];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.numberOfLines = 0;
    [self configureLabel:self.detailLabel text:self.post.detailedDescription fontSize:16];
    
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.textColor = [CMMStyles new].globalNavy;
    [self configureLabel:self.authorLabel text:self.post.owner.username fontSize:14];
    
    self.reportLabel = [[UILabel alloc] init];
    [self configureLabel:self.reportLabel text:@"..." fontSize:20];
}

- (void)displayProfileImageWithSize:(int)size padding:(int)padding {
    CGRect imageFrame = CGRectMake(12, padding, size, size);
    self.authorImage = [[UIImageView alloc] initWithFrame:imageFrame];
    self.authorImage.image = nil;
    [self.authorImage setImageWithURL:[NSURL URLWithString:self.post.owner.profileImage.url] placeholderImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    self.authorImage.layer.cornerRadius = size/2;
    self.authorImage.clipsToBounds = YES;
    [self.view addSubview:self.authorImage];
    
    self.authorImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segueToProfile)];
    [self.authorImage addGestureRecognizer:profileTap];
}

- (void)layOutLabelsWithImageSize:(int)imageSize padding:(int)topPadding {
    [self topLeftRightConstraints:self.titleLabel withPadding:UIEdgeInsetsMake(topPadding + imageSize + 36, 12, 12, 12)];
    UIEdgeInsets categoryPadding = UIEdgeInsetsMake(topPadding + imageSize + 12, 12, 12, 12);
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(categoryPadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(categoryPadding.left);
        make.width.equalTo(@(self.categoryLabel.intrinsicContentSize.width));
    }];
    UIEdgeInsets datePadding = UIEdgeInsetsMake(topPadding + imageSize + 12, 12, 12, 12);
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(datePadding.top);
        make.left.equalTo(self.categoryLabel.mas_right).with.offset(datePadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-datePadding.right);
    }];
    UIEdgeInsets detailPadding = UIEdgeInsetsMake(12, 12, 12, 12);
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(detailPadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(detailPadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-detailPadding.right);
    }];
    UIEdgeInsets authorPadding = UIEdgeInsetsMake(topPadding + imageSize/2, 12, 12, 12);
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(authorPadding.top);
        make.left.equalTo(self.authorImage.mas_right).with.offset(authorPadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-authorPadding.right);
    }];
    UIEdgeInsets reportPadding = UIEdgeInsetsMake(topPadding + imageSize/2, 12, 12, 12);
    [self.reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(reportPadding.top);
        //make.left.equalTo(self.authorImage.mas_right).with.offset(authorPadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-reportPadding.right);
    }];
}

- (void)createButtons {
    UIColor *tealColor = [CMMStyles getTealColor];
    
    BOOL showChatButton = YES;
    int resourceLeftPadding;
    NSString *blockingKey = [self.post.owner.objectId stringByAppendingString:@"-blockedUsers"];
    NSMutableArray *blockedUsers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:blockingKey]];
    for (NSString *userID in blockedUsers) {
        if ([userID isEqualToString:CMMUser.currentUser.objectId]) {
            showChatButton = NO;
            break;
        }
    }
    if ([self.post.owner.objectId isEqualToString:CMMUser.currentUser.objectId]) {
        showChatButton = NO;
    }
    if (CMMUser.currentUser.strikes.intValue >= 3) {
        showChatButton = NO;
    }
    
    // chat button
    if (showChatButton) {
        self.chatButton = [[UIButton alloc] init];
        [self.chatButton addTarget:self action:@selector(didPressChat) forControlEvents:UIControlEventTouchUpInside];
        [self.chatButton setTitle:@"Let's Chat!" forState:UIControlStateNormal];
        [self.chatButton setBackgroundColor:tealColor];
        [self.chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:self.chatButton];
        UIEdgeInsets chatPadding = UIEdgeInsetsMake(30, 12, 12, self.view.frame.size.width/2 + 6);
        [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLabel.mas_bottom).with.offset(chatPadding.top);
            make.left.equalTo(self.view.mas_left).with.offset(chatPadding.left);
            make.right.equalTo(self.view.mas_right).with.offset(-chatPadding.right);
        }];
        resourceLeftPadding = self.view.frame.size.width/2 + 6;
    } else {
        resourceLeftPadding = 12;
    }
    
    // resources button
    self.resourceButton = [[UIButton alloc] init];
    [self.resourceButton addTarget:self action:@selector(didPressResources) forControlEvents:UIControlEventTouchUpInside];
    [self.resourceButton setTitle:@"Tell Me More!" forState:UIControlStateNormal];
    [self.resourceButton setBackgroundColor:[UIColor grayColor]];
    [self.resourceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.resourceButton];
    UIEdgeInsets resourcePadding = UIEdgeInsetsMake(30, resourceLeftPadding, 12, 12);
    [self.resourceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(resourcePadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(resourcePadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-resourcePadding.right);
    }];
    
    self.reportLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *reportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapReport)];
    [self.reportLabel addGestureRecognizer:reportTap];
}

- (void)didTapReport {
    [[CMMParseQueryManager shared] reportPost:self.post];
    [self.post saveInBackground];
}

- (void)segueToProfile {
    CMMProfileVC *profileVC = [[CMMProfileVC alloc] init];
    profileVC.user = self.post.owner;
    [[self navigationController] pushViewController:profileVC animated:YES];
}

- (void)topLeftRightConstraints:(UIView *)view withPadding:(UIEdgeInsets)padding {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top);
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
}

- (void)didPressChat {
    [[CMMParseQueryManager shared] conversationWithTopic:self.post.topic postAuthor:self.post.owner withCompletion:^(CMMConversation *chat, NSError *error) {
        CMMChatVC *chatVC = [[CMMChatVC alloc] init];
        chatVC.conversation = chat;
        chatVC.isUserOne = YES;
        [self.post addObject:[NSDate date] forKey:@"userChatTaps"];
        [self.post saveInBackground];
        [[self navigationController] pushViewController:chatVC animated:YES];
    }];
}

- (void)didPressResources {
    CMMTopHeadlinesVC *resourcesVC = [[CMMTopHeadlinesVC alloc]init];
    UINavigationController *resourcesNavigation = [[UINavigationController alloc]initWithRootViewController:resourcesVC];

    
//    for (int x = 0;x < self.post.topic.length; ++x ){
//        char currentCharacter = [self.post.topic characterAtIndex:x];
//        if (currentCharacter == ' '){
//
//        }
//    }
    resourcesVC.category = self.post.topic;

    [self.navigationController pushViewController:resourcesVC animated:YES];
    //[self presentViewController:resourcesVC animated:YES completion:^{
    //}];
}

@end
