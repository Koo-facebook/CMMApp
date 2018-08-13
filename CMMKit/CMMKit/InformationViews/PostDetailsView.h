//
//  PostDetailsView.h
//  CMMKit
//
//  Created by Keylonnie Miller on 8/1/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailsView : UIView

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) UIButton *chatButton;
@property (strong, nonatomic) UIButton *resourcesButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


-(void)setPostWithTitle:(NSString*)title category:(NSString *)category user:(NSString *)user time:(NSString *)time description:(NSString *)description showingChatButton: (BOOL) chatButtonView;

@end
