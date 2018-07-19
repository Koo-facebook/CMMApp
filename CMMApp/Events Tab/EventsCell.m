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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEvent:(CMMEvent *)event {
    _event = event;
    
    self.eventName.text = self.event.title;
    NSLog(@"%@", self.event.title);
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)eventsCell {
    self = [super initWithStyle:style reuseIdentifier:eventsCell];
    if (self) {
        self.eventName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        self.eventName.textColor = [UIColor blackColor];
        self.eventName.font = [UIFont fontWithName:@"Arial" size:9];
        
        NSLog(@"Inside of the cell setting layout/style");
        
        [self addSubview:self.eventName];
    }
    return self;
}

@end
