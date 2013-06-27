//
//  FirstViewController.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 09/01/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)locationManager:(CLLocationManager *)managerdidUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get current location
    [self getlocation];
    
    // Init weather model
    _weather = [Weather alloc];
    
	// Background color
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    
    // Time
    NSDate *date = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dataComps = [gregorianCal components: (NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate: date];
    
    // Views
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"%d:%@", [dataComps hour], [NSString stringWithFormat:@"%02d", [dataComps minute]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Location Methods

- (void)getlocation {
    // Get current location
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
}


// Failed to get current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    // Call alert
	[errorAlert show];
}

// Got location and now update
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    User* user = [User sharedInstance];
    [user setLocation:newLocation];
    
    if (currentLocation != nil) {
        // Stop Location Manager
        [locationManager stopUpdatingLocation];
        
        // Update meteo data
        dispatch_queue_t myQueue = dispatch_queue_create("Get meteo",NULL);
        dispatch_async(myQueue, ^{
            
            WeatherWebservice* ws = [[WeatherWebservice alloc] init];
            _weather = [ws getTodayWeatherForLocation:currentLocation];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                
                // Update the UI
                _placeLabel.text = [_weather place];
                _speedLabel.text = [NSString stringWithFormat:@"%.02fkm/h", [_weather windSpeed]];
                _humidityLabel.text = [NSString stringWithFormat:@"%.02f%%", [_weather humidity]];
                _temperatureLabel.text = [NSString stringWithFormat:@"%.02fF°", [_weather temperature]];
                
                self.weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [_weather iconName]]];
            });
        });
    }
}

@end
