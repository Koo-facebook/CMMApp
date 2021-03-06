//
//  CMMEventsVC.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CMMKit/CMMKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CMMEventsVC : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, EventsDelegate>


@end
