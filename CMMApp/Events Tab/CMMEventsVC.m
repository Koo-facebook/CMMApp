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

@interface CMMEventsVC () 

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *eventList;
@property (strong, nonatomic) NSArray *venueList;

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
    [self updateConstraints];
    
    [self fetchEvents];

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

//Adding Pins
-(void) addingPins: (CLLocationCoordinate2D)location {
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    //CLLocationCoordinate2D venueLocation = CLLocationCoordinate2DMake(37.783333, -122.416667);
    annotation.coordinate = location;
    annotation.title = @"Event";
    [self.mapView addAnnotation:annotation];
}

-(void) fetchEvents {
    [[CMMEventAPIManager shared] getAllEvents:^(NSArray *eventsArray, NSError *error) {
       if (eventsArray) {
        //NSLog(@"%@", events[1]);
            self.eventList = eventsArray;
            for (CMMEvent *event in eventsArray) {
                NSString *name = event.title;
                NSLog(@"%@", name);
                NSNumber *lat = event.venue.latitude;
                NSLog(@"%@", event.venue.longitude.stringValue);
                NSNumber *lon = event.venue.longitude;
                NSLog(@"%@", lon);
                CLLocationCoordinate2D venueLocation = CLLocationCoordinate2DMake(lat.floatValue,lon.floatValue);
                [self addingPins:venueLocation];
            }
            NSLog(@"😎😎😎 Successfully loaded events table");
            [self.tableView reloadData];
        } else {
           NSLog(@"😫😫😫 Error getting events: %@", error.localizedDescription);
        }
    }
     ];
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
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventList.count;
}


@end
