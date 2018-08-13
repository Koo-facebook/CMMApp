//
//  InterestsViewCell.h
//  CMMApp
//
//  Created by Keylonnie Miller on 8/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMUser.h"

@interface InterestsViewCell : UICollectionViewCell

@property (strong, nonatomic) CMMUser *user;
@property (strong, nonatomic) NSString *title;

@end
