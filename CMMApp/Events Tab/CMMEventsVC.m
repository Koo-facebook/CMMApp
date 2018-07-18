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
#import "EventsCell.h"

@interface CMMEventsVC () 

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CMMEventsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Events";
    
    //Create items on View Controller
    [self createMap];
    [self createTableView];
    [self updateConstraints];
}

- (void) updateConstraints {
    // Map View
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.superview.mas_top);
        make.left.equalTo(self.mapView.superview.mas_left);
        make.width.equalTo(self.mapView.superview.mas_width);

        double mapHeight = screenSize.height/1.75;
        make.height.equalTo(@(mapHeight));
    }];
    // Table View
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view.mas_width);
    }];
}

//Create mapView
- (void) createMap {
    self.mapView = [[MKMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

//Delegate function of mapView that will center map on user location
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

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
