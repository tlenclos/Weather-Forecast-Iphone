//
//  WeatherWebservice.h
//  Weather forecast
//
//  Created by Thibault Lenclos on 22/06/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Const.h"
#import "Weather.h"

@interface WeatherWebservice : NSObject

- (Weather*) getTodayWeatherForLocation:(CLLocation*)location;
- (NSMutableArray*) getWeekWeatherForLocation:(CLLocation*)location;

@end
