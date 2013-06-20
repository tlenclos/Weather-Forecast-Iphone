//
//  FirstViewController.h
//  Weather forecast
//
//  Created by Thibault Lenclos on 09/01/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "Weather.h"

@interface FirstViewController : UIViewController <CLLocationManagerDelegate> {
        CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) Weather *weather;

@end
