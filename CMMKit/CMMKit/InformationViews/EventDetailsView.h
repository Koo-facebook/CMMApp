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

-(void)setEventWithTitle:(NSString*)title location:(NSString *)location startTime:(NSString *)startTime endTime:(NSString *)endTime description:(NSString *)description;

@end
