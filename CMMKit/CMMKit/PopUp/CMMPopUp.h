//
//  CMMPopUp.h
//  CMMKit
//
//  Created by Keylonnie Miller on 7/26/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMPopUp : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadLabel;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *overallView;

-(void)setImage:(UIImage *)image;

@end
