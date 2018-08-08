//
//  PostTableViewCell.m
//  CMMKit
//
//  Created by Keylonnie Miller on 8/2/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "PostTableViewCell.h"

@interface PostTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak,nonatomic) IBOutlet UIImageView *profileImage;

@end
@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if(self) {
//        [self customInit];
//    }
//    return self;
//}
//
//-(instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self customInit];
//    }
//    return self;
//}

-(void)customInit {
    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    UINib *nibName = [UINib nibWithNibName:@"PostTableViewCell" bundle:bundle ];
    self.contentView = [[nibName instantiateWithOwner:self options:nil] firstObject];

    self.contentView.center = self.center;
    self.contentView.autoresizingMask = UIViewAutoresizingNone;
    self.contentView.frame = self.bounds;

    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5;

    self.titleLabel.text = @"";
    self.categoryLabel.text = @"";
    self.usernameLabel.text = @"";
    self.timeLabel.text = @"";
    self.profileImage.image = nil;

    [self addSubview:self.contentView];

}

-(void)setPostCellWithTitle:(NSString*)title user:(NSString *)username photo:(UIImage *)image time:(NSString *)time category:(NSString *)category {
    
    [self customInit];
    self.titleLabel.text = title;
    self.categoryLabel.text = category;
    self.usernameLabel.text = username;
    self.timeLabel.text = time;
    self.profileImage.image = image;
}

@end
