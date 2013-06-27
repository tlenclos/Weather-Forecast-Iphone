//
//  Weather.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 18/03/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize place;
@synthesize temperature;
@synthesize humidity;
@synthesize windSpeed;
@synthesize pressure;
@synthesize iconName;
@synthesize day;

- (id)init
{
    self = [super init];
    
    if (self) {
        place = @"";
        temperature = 0.0;
        humidity = 0.0;
        windSpeed = 0.0;
        pressure = 0;
        iconName = @"";
        day = [[NSDate alloc] init];
    }
    
    return self;
}

@end
