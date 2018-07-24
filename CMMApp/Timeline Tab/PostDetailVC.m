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

@interface PostDetailVC ()
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *authorImage;
@property (strong, nonatomic) UIButton *chatButton;
@property (strong, nonatomic) UIButton *resourceButton;
@end

@implementation PostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureDetails:(CMMPost *)post {
    self.view.backgroundColor = [UIColor whiteColor];
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
    [label setFont:[CMMStyles getFontWithSize:fontSize Weight:UIFontWeightLight]];
}

- (void)createLabels {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    [self configureLabel:self.titleLabel text:self.post.topic fontSize:16];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [CMMStyles getTealColor];
    [self configureLabel:self.dateLabel text:[self.post.createdAt timeAgoSinceNow] fontSize:14];
    
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.textColor = [CMMStyles getTealColor];
    [self configureLabel:self.categoryLabel text:self.post.category fontSize:14];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.numberOfLines = 0;
    [self configureLabel:self.detailLabel text:self.post.detailedDescription fontSize:16];
    
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.textColor = [CMMStyles getTealColor];
    [self configureLabel:self.authorLabel text:self.post.owner.username fontSize:14];
}

- (void)displayProfileImageWithSize:(int)size padding:(int)padding {
    CGRect imageFrame = CGRectMake(12, padding, size, size);
    self.authorImage = [[UIImageView alloc] initWithFrame:imageFrame];
    self.authorImage.image = nil;
    [self.authorImage setImageWithURL:[NSURL URLWithString:self.post.owner.profileImage.url] placeholderImage:[UIImage imageNamed:@"placeholderProfileImage"]];
    self.authorImage.layer.cornerRadius = size/2;
    self.authorImage.clipsToBounds = YES;
    [self.view addSubview:self.authorImage];
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
}

- (void)createButtons {
    UIColor *tealColor = [UIColor colorWithRed:54/255.f green:173/255.f blue:157/255.f alpha:1];
    
    // chat button
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
    
    // resources button
    self.resourceButton = [[UIButton alloc] init];
    [self.resourceButton addTarget:self action:@selector(didPressResources) forControlEvents:UIControlEventTouchUpInside];
    [self.resourceButton setTitle:@"Tell Me More!" forState:UIControlStateNormal];
    [self.resourceButton setBackgroundColor:[UIColor grayColor]];
    [self.resourceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.resourceButton];
    UIEdgeInsets resourcePadding = UIEdgeInsetsMake(30, self.view.frame.size.width/2 + 6, 12, 12);
    [self.resourceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).with.offset(resourcePadding.top);
        make.left.equalTo(self.view.mas_left).with.offset(resourcePadding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-resourcePadding.right);
    }];
}

- (void)topLeftRightConstraints:(UIView *)view withPadding:(UIEdgeInsets)padding {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top);
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
}

- (void)didPressChat {
    [CMMConversation createConversation:self.post.owner topic:self.post.topic withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            CMMChatVC *chatVC = [[CMMChatVC alloc] init];
            //chatVC.conversation = CMMUser.currentUser.conversations[CMMUser.currentUser.conversations.count - 1];
            [[self navigationController] pushViewController:chatVC animated:YES];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)didPressResources {
    NSLog(@"Resources page does not exist yet");
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
