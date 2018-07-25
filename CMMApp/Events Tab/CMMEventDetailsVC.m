//
//  CMMEventDetailsVC.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/20/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMEventDetailsVC.h"
#import "Masonry.h"


@interface CMMEventDetailsVC ()

@end

@implementation CMMEventDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Event Details";
    [self createScrollView];
    [self createEventName];
    [self createDate];
    [self createTime];
    [self createLocation];
    [self createDescription];
    [self createAddToCalendarButton];
    
    //Fix layout
    [self updateConstraints];
}

- (void)updateConstraints {
    
    // Scroll View
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroll.superview.mas_top);
        make.centerX.equalTo(self.scroll.superview.mas_centerX);
        make.height.equalTo(@(self.view.frame.size.height));
        make.width.equalTo(@(self.view.frame.size.width));
    }];
    
    // Event Name Label
    [self.eventName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroll.mas_top).offset(115);
        make.centerX.equalTo(self.scroll.mas_centerX);
        //make.height.equalTo(@(self.eventName.intrinsicContentSize.height));
        make.width.equalTo(@(340));
    }];
    
    // Date Label
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventName.mas_bottom).offset(35);
        make.centerX.equalTo(self.scroll.mas_centerX);
        make.width.equalTo(@(self.date.intrinsicContentSize.width));
        make.height.equalTo(@(self.date.intrinsicContentSize.height));
    }];
    
    // Time Label
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.date.mas_bottom).offset(20);
        make.centerX.equalTo(self.scroll.mas_centerX);
        make.width.equalTo(@(self.time.intrinsicContentSize.width));
        make.height.equalTo(@(self.time.intrinsicContentSize.height));
    }];
    
    // Location Label
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(20);
        make.centerX.equalTo(self.scroll.mas_centerX);
        make.width.equalTo(@(self.location.intrinsicContentSize.width));
        make.height.equalTo(@(self.location.intrinsicContentSize.height));
    }];
    
     // Event Description Label
     [self.eventDescription mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.location.mas_bottom).offset(40);
     make.centerX.equalTo(self.scroll.mas_centerX);
     make.width.equalTo(@(325));
     }];
     
    // Add to Calendar Button
    [self.addToCalendarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventDescription.mas_bottom).offset(18);
        make.centerX.equalTo(self.scroll.mas_centerX);
        make.width.equalTo(@(self.addToCalendarButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.addToCalendarButton.intrinsicContentSize.height));
    }];

}

-(void) createEventName{
self.eventName = [[UILabel alloc] init];
self.eventName.textColor = [UIColor blackColor];
self.eventName.font = [UIFont fontWithName:@"Arial" size:26];
self.eventName.numberOfLines = 0;
self.eventName.textAlignment = NSTextAlignmentCenter;
    self.eventName.text = self.event.title;
[self.scroll addSubview:self.eventName];
}

-(void) createDate {
self.date = [[UILabel alloc] init];
self.date.textColor = [UIColor blackColor];
self.date.font = [UIFont fontWithName:@"Arial" size:16];
    //Format date to appear as "July 21, 2018" and set
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self.event.startTime];
    
    [formatter setDateFormat:@"MMMM dd, yyyy"];
self.date.text = [formatter stringFromDate:date];
    
[self.scroll addSubview:self.date];
}

-(void) createTime {
self.time = [[UILabel alloc] init];
self.time.textColor = [UIColor blackColor];
self.time.font = [UIFont fontWithName:@"Arial" size:16];
    //Formate time to appear as "4:30 PM - 6:00 PM" and set
    NSDateFormatter *timeformatter = [[NSDateFormatter alloc] init];
    [timeformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *stime = [timeformatter dateFromString:self.event.startTime];
    NSDate *etime = [timeformatter dateFromString:self.event.endTime];
    
    [timeformatter setDateFormat:@"h:mm a"];
    NSString *startTime = [timeformatter stringFromDate:stime];
    NSString *endTime = [timeformatter stringFromDate:etime];
    
    NSString *dashAdded = [startTime stringByAppendingString:@"-"];
    NSString *interval = [dashAdded stringByAppendingString:endTime];
    self.time.text = interval;
[self.scroll addSubview:self.time];
}

-(void) createLocation {
    self.location = [[UILabel alloc] init];
    self.location.textColor = [UIColor blackColor];
    self.location.font = [UIFont fontWithName:@"Arial" size:16];
    self.location.text = self.event.venue.address1;
    [self.scroll addSubview:self.location];
}

-(void) createDescription {
    self.eventDescription = [[UILabel alloc] init];
    self.eventDescription.textColor = [UIColor blackColor];
    self.eventDescription.font = [UIFont fontWithName:@"Arial" size:14];
    self.eventDescription.numberOfLines = 0;
    self.eventDescription.text = self.event.details;
    //self.eventDescription.textAlignment = NSTextAlignmentJustified;
    [self.scroll addSubview:self.eventDescription];
}

// Create Add to Calendar Button
- (void)createAddToCalendarButton {
    self.addToCalendarButton = [[UIButton alloc] init];
    [self.addToCalendarButton setTitle:@"Add to Calendar" forState:UIControlStateNormal];
    [self.addToCalendarButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.addToCalendarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.addToCalendarButton addTarget:self action:@selector(createCalendarEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:self.addToCalendarButton];
}

-(void)createScrollView {
    self.scroll = [[UIScrollView alloc]init];
    self.scroll.delegate = self;
    self.scroll.showsVerticalScrollIndicator=YES;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.scrollEnabled=YES;
    self.scroll.userInteractionEnabled=YES;
    [self.view addSubview:self.scroll];
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 325);
}

-(void)createCalendarEvent {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        //Event Title
        event.title = self.event.title;
        
        NSDateFormatter *timeformatter = [[NSDateFormatter alloc] init];
        [timeformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *startTime = [timeformatter dateFromString:self.event.startTime];
        NSDate *endTime = [timeformatter dateFromString:self.event.endTime];

        //Start Date & End Date
        event.startDate = startTime;
        NSLog(@"%@", event.startDate);//today
        event.endDate = endTime;
        
        //Calendar to store in
        event.calendar = [store defaultCalendarForNewEvents];
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    }];
    [self createAlert:@"Event Added" message:@"Event has been successfully added to calendar"];
    NSLog(@"Add to Calendar Button Pressed");
}

// Create alert with given message and title
- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

@end
