//
//  CMMEventDetailsVC.h
//  CMMApp
//
//  Created by Keylonnie Miller on 7/20/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <CMMKit/CMMKit.h>
#import "CMMEvent.h"
#import "CMMVenue.h"

@interface CMMEventDetailsVC : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *eventDetailsView;
@property (strong, nonatomic) UILabel *eventName;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *location;
@property (strong, nonatomic) UILabel *eventDescription;
@property (nonatomic, strong) UIButton *addToCalendarButton;
@property (nonatomic, strong) UIScrollView *scroll;
@property (strong, nonatomic) CMMEvent *event;
@property (strong, nonatomic) CMMVenue *venue;

@end
