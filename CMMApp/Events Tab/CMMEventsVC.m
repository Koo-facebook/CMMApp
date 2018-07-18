//
//  CMMEventsVC.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#define  screenSize self.view.frame.size

#import "CMMEventsVC.h"
#import "Masonry.h"

@interface CMMEventsVC () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CMMEventsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Events";
    
    [self createMap];
    [self updateConstraints];
}

- (void) updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.superview.mas_top).offset(120);
        make.centerX.equalTo(self.titleLabel.superview.mas_centerX);
        make.height.equalTo(@(self.titleLabel.intrinsicContentSize.height));
        make.width.equalTo(@(self.titleLabel.intrinsicContentSize.width));
    }];
}



- (void) createMap {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height/1.75)];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.22;
    span.longitudeDelta = 0.22;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}
- (void) createTableView {
    
}

@end
