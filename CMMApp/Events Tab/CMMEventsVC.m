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
#import "CMMEventAPIManager.h"
#import "CMMEvent.h"
#import "CMMEventDetailsVC.h"
#import "CMMVenue.h"

@interface CMMEventsVC () 

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *userLongitude;
@property (strong, nonatomic) NSNumber *userLatitude;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *eventList;
@property (strong, nonatomic) NSMutableArray *venueList;


@end

@implementation CMMEventsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.eventList = [[NSArray alloc]init];
    //Navigation Bar Set-up
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Events";
    
    [self.tableView registerClass:[EventsCell class] forCellReuseIdentifier:@"eventsCell"];
    
    //Create items on View Controller
    [self createMap];
    [self createTableView];
    [self createPullToRefresh];
    [self updateConstraints];
    
    //Get location of user to filter events
    [self getCurrentLocation];
    
    //Get events
    //[self fetchEvents];

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

//Adding Pins
-(void) addingPins: (CLLocationCoordinate2D)location {
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    //CLLocationCoordinate2D venueLocation = CLLocationCoordinate2DMake(37.783333, -122.416667);
    annotation.coordinate = location;
    annotation.title = @"Event";
    [self.mapView addAnnotation:annotation];
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

-(void) getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Request Authorization
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // Start Updating Location only when user authorized us
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        double lon = currentLocation.coordinate.longitude;
        self.userLongitude = [NSNumber numberWithFloat:lon];
        NSLog(@"%@", self.userLongitude);
        double lat = currentLocation.coordinate.latitude;
        self.userLatitude = [NSNumber numberWithFloat:lat];
        NSLog(@"%@", self.userLatitude);
        [self fetchEvents];
    }
}

//Warnings for User (map errors)
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
        } break;
        case kCLAuthorizationStatusDenied: {
            [self createAlert:@"Location Services are off!" message:@"Location services are currently disabled. \nTo enable, go to Settings>App_Name>Location>\nWhile Using the App."];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            NSLog(@"user permits location, do nothing...");
            [self.locationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self createAlert:@"No Internet Connection!" message:@"Sorry! Please check your internet connection."];
    
}

-(void) fetchEvents {
    [[CMMEventAPIManager shared] getAllEventswithLatitude:self.userLatitude withLongitude:self.userLongitude withCompletion:^(NSArray *events, NSError *error) {
        if (events) {
            NSLog(@"I am in the fetch Events method");
            self.eventList = events;
            for (CMMEvent *event in events) {
                NSString *name = event.title;
                NSLog(@"%@", name);
                [[CMMEventAPIManager shared] pullVenues:event.venue_id withCompletion:^(NSDictionary *venues, NSError *error) {
                    NSNumber *latitude = venues[@"latitude"];
                    NSNumber *longitude = venues [@"longitude"];
                    //NSLog(@"Latitude: %@", latitude);
                    //NSLog(@"Longitude: %@", longitude);
                    CLLocationCoordinate2D venueLocation = CLLocationCoordinate2DMake(latitude.floatValue,longitude.floatValue);
                    [self addingPins:venueLocation];
                }
            ];
            }
            NSLog(@"😎😎😎 Successfully loaded events table");
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting events: %@", error.localizedDescription);
        }
    }
     ];
    [self.locationManager stopUpdatingLocation];
}

// Create alert with given message and title
- (void)createAlert:(NSString *)alertTitle message:(NSString *)errorMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:errorMessage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

//Create tableView
- (void) createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 100;
    
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventsCell"];
    EventsCell *cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventsCell"];
    
    cell.event = self.eventList[indexPath.row];
    //NSLog(@"%@", cell.event);
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMEventDetailsVC *eventDetailsVC = [[CMMEventDetailsVC alloc]init];
    //UINavigationController *eventDetailsNavigation = [[UINavigationController alloc]initWithRootViewController:eventDetailsVC];
    eventDetailsVC.event = self.eventList[indexPath.row];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
    //[self presentViewController:eventDetailsNavigation animated:YES completion:^{}];
}

-(void)createPullToRefresh {
    //Initialize pull down to refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //Linking pull down action to refresh control
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    //Adding refresh information to the tableview
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchEvents];
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

@end
