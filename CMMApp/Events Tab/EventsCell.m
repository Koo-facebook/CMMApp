//
//  EventsCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "EventsCell.h"

@implementation EventsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//Set up the layout of the cell and information within it
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)eventsCell {
    self = [super initWithStyle:style reuseIdentifier:eventsCell];
    if (self) {
        self.eventName = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 230, 85)];
        self.eventName.textColor = [UIColor blackColor];
        self.eventName.font = [UIFont fontWithName:@"Arial" size:18];
        self.eventName.numberOfLines = 0;
        [self addSubview:self.eventName];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(275, 15, 100, 55)];
        self.date.textColor = [UIColor blackColor];
        self.date.font = [UIFont fontWithName:@"Arial" size:12];
        
        [self addSubview:self.date];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(275, 40, 100, 30)];
        self.time.textColor = [UIColor blackColor];
        self.time.font = [UIFont fontWithName:@"Arial" size:12];
        
        [self addSubview:self.time];
    }
    return self;
}

//Assign event information to different properties of the cell
- (void) setEvent:(CMMEvent *)event {
    _event = event;
    
    self.eventName.text = self.event.title;
    self.date.text = @"July 19th, 2018";
    self.time.text = @"4 pm to 5pm";
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:self.event.startTime];
    self.date.text = newDate;
    NSLog(@"%@", newDate);*/
}

@end
