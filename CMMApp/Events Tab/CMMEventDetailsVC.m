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
    
    // Event Name Label
    [self.eventName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventName.superview.mas_top).offset(115);
        make.centerX.equalTo(self.eventName.superview.mas_centerX);
        make.height.equalTo(@(self.eventName.intrinsicContentSize.height));
        make.width.equalTo(@(self.eventName.intrinsicContentSize.width));
    }];
    
    // Date Label
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventName.mas_bottom).offset(35);
        make.centerX.equalTo(self.date.superview.mas_centerX);
        make.width.equalTo(@(self.date.intrinsicContentSize.width));
        make.height.equalTo(@(self.date.intrinsicContentSize.height));
    }];
    
    // Time Label
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.date.mas_bottom).offset(20);
        make.centerX.equalTo(self.time.superview.mas_centerX);
        make.width.equalTo(@(self.time.intrinsicContentSize.width));
        make.height.equalTo(@(self.time.intrinsicContentSize.height));
    }];
    
    // Location Label
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(20);
        make.centerX.equalTo(self.location.superview.mas_centerX);
        make.width.equalTo(@(self.location.intrinsicContentSize.width));
        make.height.equalTo(@(self.location.intrinsicContentSize.height));
    }];
    
     // Event Description Label
     [self.eventDescription mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.location.mas_bottom).offset(40);
     make.centerX.equalTo(self.eventDescription.superview.mas_centerX);
     make.width.equalTo(@(325));
     }];
     
    // Add to Calendar Button
    [self.addToCalendarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventDescription.mas_bottom).offset(18);
        make.centerX.equalTo(self.eventDescription.superview.mas_centerX);
        make.width.equalTo(@(self.addToCalendarButton.intrinsicContentSize.width));
        make.height.equalTo(@(self.addToCalendarButton.intrinsicContentSize.height));
    }];

}

-(void) createEventName{
self.eventName = [[UILabel alloc] init];
self.eventName.textColor = [UIColor blackColor];
self.eventName.font = [UIFont fontWithName:@"Arial" size:26];
self.eventName.numberOfLines = 0;
    self.eventName.text = @"March on Washington";
[self.view addSubview:self.eventName];
}

-(void) createDate {
self.date = [[UILabel alloc] init];
self.date.textColor = [UIColor blackColor];
self.date.font = [UIFont fontWithName:@"Arial" size:16];
    self.date.text = @" March 23rd, 2018";
[self.view addSubview:self.date];
}

-(void) createTime {
self.time = [[UILabel alloc] init];
self.time.textColor = [UIColor blackColor];
self.time.font = [UIFont fontWithName:@"Arial" size:16];
    self.time.text = @"8:00 AM to 5:00 PM";
[self.view addSubview:self.time];
}

-(void) createLocation {
    self.location = [[UILabel alloc] init];
    self.location.textColor = [UIColor blackColor];
    self.location.font = [UIFont fontWithName:@"Arial" size:16];
    self.location.text = @"1600 Pennsylvania Ave, Washington D.C., USA";
    [self.view addSubview:self.location];
}

-(void) createDescription {
    self.eventDescription = [[UILabel alloc] init];
    self.eventDescription.textColor = [UIColor blackColor];
    self.eventDescription.font = [UIFont fontWithName:@"Arial" size:14];
    self.eventDescription.numberOfLines = 0;
    self.eventDescription.text = @"Eyeing this month as the last, best chance for a deal to ensure that nearly 700,000 Dreamers be granted reprieve from deportation, thousands of protesters will descend on the US Capitol and Congressional offices around the country to demand action on the contentious issue.We ask the government to pass a version of the DREAM Act that could preserve the sense of normalcy that the Deferred Action for Childhood Arrivals (DACA) program granted them. Dreamers and activists are hoping that Saturday's nationwide protest will help tip the scales and pressure Congress to pass the Dream Act bill. Come join us in our fight for the dreamers!";
    self.eventDescription.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:self.eventDescription];
}

// Create Add to Calendar Button
- (void)createAddToCalendarButton {
    self.addToCalendarButton = [[UIButton alloc] init];
    [self.addToCalendarButton setTitle:@"Add to Calendar" forState:UIControlStateNormal];
    [self.addToCalendarButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.addToCalendarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    //[self.addToCalendarButton addTarget:self action:@selector(addToCalendarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addToCalendarButton];
}
@end
