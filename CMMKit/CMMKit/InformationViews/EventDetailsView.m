//
//  EventDetailsView.m
//  CMMKit
//
//  Created by Keylonnie Miller on 8/1/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import "EventDetailsView.h"
@interface EventDetailsView ()

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

@end

@implementation EventDetailsView

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
    UINib *nibName = [UINib nibWithNibName:@"EventDetailsView" bundle:bundle ];
    self.detailsView = [[nibName instantiateWithOwner:self options:nil] firstObject];
    
   // self.blurredView.backgroundColor = [UIColor colorWithRed:(CGFloat)(9.0/255.0) green:(CGFloat)(99.0/255.0) blue:(CGFloat)(117.0/255.0) alpha:0.3];
    
    self.detailsView.center = self.center;
    self.detailsView.autoresizingMask = UIViewAutoresizingNone;
// CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/4, 230, 230);
    //self.contentView.frame = self.bounds;
    
    //self.blurredView.frame = self.frame;
    
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.layer.cornerRadius = 15;
    
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 0;
    self.locationLabel.text = @"";
    self.dateLabel.text = @"";
    self.timeLabel.text = @"";
    self.detailsLabel.text = @"";
    self.detailsLabel.numberOfLines = 0;
    self.addToCalendarButton.titleLabel.text = @"Add to Calendar";
    
    //[self addSubview:self.blurredView];
    //[self addSubview:self.blurredView];
    [self addSubview:self.detailsView];
   // [self.contentView addSubview:self.detailsView];
   // [self.contentView addSubview:self.scrollView];
}

-(void) layoutSubviews {
    [self layoutIfNeeded];
    self.detailsView.layer.masksToBounds = YES;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.layer.cornerRadius = 35;
}

-(void)setEventWithTitle:(NSString*)title location:(NSString *)location startTime:(NSString *)startTime endTime:(NSString *)endTime description:(NSString *)description {
    self.titleLabel.text = title;
    self.locationLabel.text = location;
    
    //Holders
    self.titleHolder = title;
    self.startTimeHolder = startTime;
    self.endTimeHolder = endTime;
    
    //Format Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:startTime];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    self.dateLabel.text = [formatter stringFromDate:date];
    
    //Format Time
    NSDateFormatter *timeformatter = [[NSDateFormatter alloc] init];
    [timeformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *stime = [timeformatter dateFromString:startTime];
    NSDate *etime = [timeformatter dateFromString:endTime];
    
    [timeformatter setDateFormat:@"h:mm a"];
    NSString *beginTime = [timeformatter stringFromDate:stime];
    NSString *finishTime = [timeformatter stringFromDate:etime];
    
    NSString *dashAdded = [beginTime stringByAppendingString:@"-"];
    NSString *interval = [dashAdded stringByAppendingString:finishTime];
    self.timeLabel.text = interval;
    
    self.detailsLabel.text = description;
}

- (IBAction)createCalendarEvent:(UIButton *)sender {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        //Event Title
        event.title = self.titleHolder;

        NSDateFormatter *timeformatter = [[NSDateFormatter alloc] init];
        [timeformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *startTime = [timeformatter dateFromString:self.startTimeHolder];
        NSDate *endTime = [timeformatter dateFromString:self.endTimeHolder];

        //Start Date & End Date
        event.startDate = startTime;
        NSLog(@"%@", event.startDate);//today
        event.endDate = endTime;

        //Calendar to store in
        event.calendar = [store defaultCalendarForNewEvents];

        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    }];
    //[self presentModalStatusView];
    NSLog(@"Add to Calendar Button Pressed");
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
}



-(void) didMoveToSuperview {
    //Fade in when added to SuperView
    //Then add a timer to remove the view
    self.detailsView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.15 animations:^{self.detailsView.alpha = 1.0; self.detailsView.transform = CGAffineTransformIdentity;}];
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeSelf) userInfo:nil repeats:false];
}

/*
-(void) removeSelf {
    // Animate removal of view
    [UIView animateWithDuration:3 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        self.contentView.alpha = 0;}
     ];
    [self removeFromSuperview];
    
}*/

@end
