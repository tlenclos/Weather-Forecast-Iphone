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

- (id)init
{
    self = [super init];
    
    if (self) {
        place = @"";
        temperature = 0.0;
        humidity = 0.0;
        windSpeed = 0.0;
        pressure = 0;
    }
    
    return self;
}

+ (NSDictionary *) apiQuery:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kAPIAddress,query];
    NSURL * url = [NSURL URLWithString:urlString];
    
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingAllowFragments error:nil];
}

- (Boolean) getTodayWeatherForLocation:(CLLocation*)location
{
    // Build query
    NSString * query = @"city?";
    query = [query stringByAppendingFormat:@"&lat=%f", location.coordinate.latitude];
    query = [query stringByAppendingFormat:@"&lon=%f", location.coordinate.longitude];
    query = [query stringByAppendingFormat:@"&cnt=%d", 1];
    
    NSArray *jsonResponse = [[[Weather apiQuery:query] objectForKey:@"list"] allObjects];

    if (!jsonResponse) {
        NSLog(@"Error parsing JSON");
    } else {
        NSLog(@"JSON: %@", [jsonResponse objectAtIndex:0]);
        
        place = [[jsonResponse objectAtIndex:0] objectForKey:@"name"];
        temperature = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        humidity = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"humidity"] floatValue];
        windSpeed = [[[[jsonResponse objectAtIndex:0] objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
        pressure = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"pressure"] intValue];
    }
    
    return true;
}

@end
