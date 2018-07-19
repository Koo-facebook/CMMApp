//
//  EventsCell.h
//  CMMApp
//
//  Created by Keylonnie Miller on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMEvent.h"

@interface EventsCell : UITableViewCell

@property (strong, nonatomic) UILabel *eventName;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) CMMEvent *event;

@end
