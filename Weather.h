//
//  Weather.h
//  Weather forecast
//
//  Created by Thibault Lenclos on 18/03/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kAPIAddress @"http://api.openweathermap.org/data/2.1/find/"

@interface Weather : NSObject

@property NSString* place;
@property float temperature;
@property float humidity;
@property float windSpeed;
@property int pressure;

// Retourne un jsonArray de la météo d'aujourd'hui
- (Boolean) getTodayWeatherForLocation:(CLLocation*)location;

@end
