//
//  Weather.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 18/03/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize temperature;
@synthesize humidity;
@synthesize windSpeed;
@synthesize pressure;

- (id)init
{
    self = [super init];
    
    if (self) {
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

- (Boolean) getTodayWeather
{
    NSString * query = @"city?";
    // Default Paris
    query = [query stringByAppendingFormat:@"&lat=%f", 48.853409];
    query = [query stringByAppendingFormat:@"&lon=%f", 2.3488];
    query = [query stringByAppendingFormat:@"&cnt=%d", 1];
    
    // Test API query
    NSArray *jsonResponse = [[[Weather apiQuery:query] objectForKey:@"list"] allObjects];
    
    if (!jsonResponse) {
        NSLog(@"Error parsing JSON");
    } else {
        NSLog(@"JSON: %@", [jsonResponse objectAtIndex:0]);
        
        temperature = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        humidity = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"humidity"] floatValue];
        windSpeed = [[[[jsonResponse objectAtIndex:0] objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
        pressure = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"pressure"] intValue];
    }
    
    return true;
}

@end
