//
//  EventDetailsView.h
//  CMMKit
//
//  Created by Keylonnie Miller on 8/1/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface EventDetailsView : UIView

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToCalendarButton;
@property (strong, nonatomic) NSString *startTimeHolder;
@property (strong, nonatomic) NSString *endTimeHolder;
@property (strong, nonatomic) NSString *titleHolder;

-(void)setEventWithTitle:(NSString*)title location:(NSString *)location startTime:(NSString *)startTime endTime:(NSString *)endTime description:(NSString *)description;

@end
