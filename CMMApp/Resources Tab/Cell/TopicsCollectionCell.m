//
//  TopicsCollectionCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/25/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TopicsCollectionCell.h"
#import "Masonry.h"

@interface TopicsCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end

@implementation TopicsCollectionCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    UINib *nibName = [UINib nibWithNibName:@"TopicsCollectionCell" bundle:bundle ];
    self.contentView = [[nibName instantiateWithOwner:self options:nil] firstObject];
    
    //self.contentView.center = self.center;
    self.contentView.autoresizingMask = UIViewAutoresizingNone;
    //CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/4, 230, 230);
    self.contentView.frame = self.bounds;
    
    self.category.text = self.title;
    
    [self addSubview:self.contentView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//
//- (void)configureCollectionCell {
//    self.contentView.backgroundColor = [UIColor purpleColor];
//
//    self.cellInfoView = [[UIView alloc]init];//WithFrame:CGRectMake(10, 10, (self.contentView.frame.size.width), 110)];
//    self.cellInfoView.backgroundColor = [UIColor purpleColor];
//    [self.contentView addSubview:self.cellInfoView];
//
//    //Set event name
//    self.title = [[UILabel alloc]init];
//    self.title.text = self.category;
//    self.title.numberOfLines = 1;
//    self.title.textColor = [UIColor whiteColor];
//    //[self.cellInfoView addSubview:self.title];
//
//
//    // Autolayout for the labels
//    UIEdgeInsets containerPadding = UIEdgeInsetsMake(10, 10, 5, 10);
//    [self.cellInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).with.offset(containerPadding.top);
//        make.left.equalTo(self.contentView.mas_left).with.offset(containerPadding.left);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-containerPadding.bottom);
//        make.right.equalTo(self.contentView.mas_right).with.offset(-containerPadding.right);
//    }];
//
//
////    UIEdgeInsets titlePadding = UIEdgeInsetsMake(12, 5, 12, 12);
////    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.cellInfoView.mas_top).offset(titlePadding.top);
////        make.left.equalTo(self.cellInfoView.mas_left).with.offset(titlePadding.left);
////        make.bottom.equalTo(self.cellInfoView.mas_bottom).with.offset(-titlePadding.bottom);
////        make.width.equalTo(@(170));
////    }];
//
//    self.cellInfoView.backgroundColor = [UIColor colorWithRed:(CGFloat)(9.0/255.0) green:(CGFloat)(99.0/255.0) blue:(CGFloat)(117.0/255.0) alpha:1];
//    self.cellInfoView.layer.cornerRadius = 10;
//    self.cellInfoView.clipsToBounds = YES;
//
//    //[self.cellInfoView.layer setBorderColor:[UIColor blackColor].CGColor];
//    //[self.cellInfoView.layer setBorderWidth:2.0f];
//}

@end
