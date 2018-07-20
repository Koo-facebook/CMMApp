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
    
    //Set event name
    self.eventName.text = self.event.title;
    //self.eventName = self.event.venue.longitude;
        
    //Format date to appear as "July 21, 2018" and set
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self.event.startTime];
    
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    self.date.text = [formatter stringFromDate:date];
    
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
    //NSLog(@"%@", self.date.text);
}


@end
