//
//  EventsCell.m
//  CMMApp
//
//  Created by Keylonnie Miller on 7/18/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "EventsCell.h"
#import "Masonry.h"

@interface EventsCell ()

@property (strong,nonatomic) UIView *cellInfoView;

@end

@implementation EventsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureEventCell:(CMMEvent*)event {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.cellInfoView = [[UIView alloc]init];//WithFrame:CGRectMake(10, 10, (self.contentView.frame.size.width), 110)];
    [self.contentView addSubview:self.cellInfoView];
    
    self.event = event;
    
    //Set event name
    self.eventName = [[UILabel alloc]init];
    self.eventName.text = self.event.title;
    self.eventName.numberOfLines = 0;
    self.eventName.textColor = [UIColor whiteColor];
    [self.cellInfoView addSubview:self.eventName];
    
    
    //Container for Date & Time
    UIView *dtContainer = [[UIView alloc]init];
    dtContainer.backgroundColor = [UIColor clearColor];
    [self.cellInfoView addSubview:dtContainer];
    
    //Format date to appear as "July 21, 2018" and set
    self.date = [[UILabel alloc]init];
    self.date.textColor = [UIColor whiteColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self.event.startTime];
    
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    self.date.text = [formatter stringFromDate:date];
    [dtContainer addSubview:self.date];
    
    //Formate time to appear as "4:30 PM - 6:00 PM" and set
    self.time = [[UILabel alloc]init];
    self.time.textColor = [UIColor whiteColor];
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
    [dtContainer addSubview:self.time];

    // Autolayout for the labels
    UIEdgeInsets containerPadding = UIEdgeInsetsMake(10, 10, 5, 10);
    [self.cellInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(containerPadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(containerPadding.left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-containerPadding.bottom);
        make.right.equalTo(self.contentView.mas_right).with.offset(-containerPadding.right);
    }];
    
    //UIEdgeInsets dtcontainerPadding = UIEdgeInsetsMake(10, 5, 5, 10);
    [dtContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellInfoView.mas_top);
        make.centerY.equalTo(self.cellInfoView.mas_centerY);
        //make.height.equalTo(@(dtContainer.intrinsicContentSize.height));
        make.right.equalTo(self.cellInfoView.mas_right);
        make.width.equalTo(@(150));
    }];
    
    UIEdgeInsets titlePadding = UIEdgeInsetsMake(12, 5, 12, 12);
    [self.eventName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellInfoView.mas_top).offset(titlePadding.top);
        make.left.equalTo(self.cellInfoView.mas_left).with.offset(titlePadding.left);
        make.bottom.equalTo(self.cellInfoView.mas_bottom).with.offset(-titlePadding.bottom);
        make.width.equalTo(@(170));
    }];
    UIEdgeInsets datePadding = UIEdgeInsetsMake(12, 5, 5, 12);
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(dtContainer.mas_top).with.offset(datePadding.top);
        make.centerY.equalTo(dtContainer.mas_centerY).offset(-12);
        make.right.equalTo(dtContainer.mas_right).offset(-10);
       // make.width.equalTo(@(self.date.intrinsicContentSize.width));
       // make.height.equalTo(@(self.date.intrinsicContentSize.height));
    }];
    UIEdgeInsets timePadding = UIEdgeInsetsMake(5, 5, 5, 12);
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.date.mas_bottom).with.offset(timePadding.top);
        make.right.equalTo(dtContainer.mas_right).offset(-10);
        //make.centerY.equalTo(dtContainer.mas_centerY);
       // make.width.equalTo(@(self.time.intrinsicContentSize.width));
        //make.height.equalTo(@(self.time.intrinsicContentSize.height));
    }];
    
    self.cellInfoView.backgroundColor = [UIColor colorWithRed:(CGFloat)(9.0/255.0) green:(CGFloat)(99.0/255.0) blue:(CGFloat)(117.0/255.0) alpha:1];
    self.cellInfoView.layer.cornerRadius = 10;
    self.cellInfoView.clipsToBounds = YES;
    
    //[self.cellInfoView.layer setBorderColor:[UIColor blackColor].CGColor];
    //[self.cellInfoView.layer setBorderWidth:2.0f];
}

////Set up the layout of the cell and information within it
//- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)eventsCell {
//    self = [super initWithStyle:style reuseIdentifier:eventsCell];
//    if (self) {
//        self.contentView.backgroundColor = [UIColor whiteColor];
//        
//        self.cellInfoView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, (self.contentView.frame.size.width), 110)];
//        [self.contentView addSubview:self.cellInfoView];
//        
//        self.cellInfoView.backgroundColor = [UIColor colorWithRed:(CGFloat)(77.0/255.0) green:(CGFloat)(179.0/255.0) blue:(CGFloat)(179.0/255.0) alpha:1];
//        self.cellInfoView.layer.cornerRadius = 10;
//        self.cellInfoView.clipsToBounds = YES;
//        
//        self.eventName = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 230, 85)];
//        self.eventName.textColor = [UIColor blackColor];
//        self.eventName.font = [UIFont fontWithName:@"Arial" size:18];
//        self.eventName.numberOfLines = 0;
//        [self.cellInfoView addSubview:self.eventName];
//        
//        self.date = [[UILabel alloc] initWithFrame:CGRectMake(275, 15, 100, 55)];
//        self.date.textColor = [UIColor blackColor];
//        self.date.font = [UIFont fontWithName:@"Arial" size:12];
//        
//        [self.cellInfoView addSubview:self.date];
//        
//        self.time = [[UILabel alloc] initWithFrame:CGRectMake(275, 40, 100, 30)];
//        self.time.textColor = [UIColor blackColor];
//        self.time.font = [UIFont fontWithName:@"Arial" size:12];
//        
//        [self.cellInfoView addSubview:self.time];
//    }
//    return self;
//}

////Assign event information to different properties of the cell
//- (void) setEvent:(CMMEvent *)event {
//    _event = event;
//
//    //Set event name
//    self.eventName.text = self.event.title;
//    //self.eventName = self.event.venue.longitude;
//
//    //Format date to appear as "July 21, 2018" and set
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    NSDate *date = [formatter dateFromString:self.event.startTime];
//
//    [formatter setDateFormat:@"MMMM dd, yyyy"];
//    self.date.text = [formatter stringFromDate:date];
//
//    //Formate time to appear as "4:30 PM - 6:00 PM" and set
//    NSDateFormatter *timeformatter = [[NSDateFormatter alloc] init];
//    [timeformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    NSDate *stime = [timeformatter dateFromString:self.event.startTime];
//    NSDate *etime = [timeformatter dateFromString:self.event.endTime];
//
//    [timeformatter setDateFormat:@"h:mm a"];
//    NSString *startTime = [timeformatter stringFromDate:stime];
//    NSString *endTime = [timeformatter stringFromDate:etime];
//
//    NSString *dashAdded = [startTime stringByAppendingString:@"-"];
//    NSString *interval = [dashAdded stringByAppendingString:endTime];
//    self.time.text = interval;
//    //NSLog(@"%@", self.date.text);
//}


@end
