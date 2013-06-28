//
//  WeatherWebservice.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 22/06/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "WeatherWebservice.h"

@implementation WeatherWebservice


+ (NSDictionary *) apiQuery:(NSString *)query
{
    NSURL * url = [NSURL URLWithString:query];
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    return  data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] : nil;
}

- (Weather*) getTodayWeatherForLocation:(CLLocation*)location
{
    Weather* weather = [[Weather alloc] init];
    
    // Build query
    NSString *query = [NSString stringWithFormat:@"%@", WS_URL];
    query = [query stringByAppendingFormat:@"city?"];
    query = [query stringByAppendingFormat:@"&lat=%f", location.coordinate.latitude];
    query = [query stringByAppendingFormat:@"&lon=%f", location.coordinate.longitude];
    query = [query stringByAppendingFormat:@"&cnt=%d", 1];
    query = [query stringByAppendingFormat:@"&units=%s", "metric"];
    
    NSArray *jsonResponse = [[[WeatherWebservice apiQuery:query] objectForKey:@"list"] allObjects];
    
    if (!jsonResponse) {
        NSLog(@"Error parsing JSON");
    } else {
        weather.place = [[jsonResponse objectAtIndex:0] objectForKey:@"name"];
        weather.temperature = [self kelvinToCelsius:[[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] floatValue]];
        weather.humidity = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"humidity"] floatValue];
        weather.windSpeed = [[[[jsonResponse objectAtIndex:0] objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
        weather.pressure = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"pressure"] intValue];
        weather.iconName = [[[[jsonResponse objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
    }
    
    return weather;
}

- (NSMutableArray*) getWeekWeatherForLocation:(CLLocation*)location
{
    // Build query
    NSString *query = [NSString stringWithFormat:@"%@", WS_URL_FORECAST];
    query = [query stringByAppendingFormat:@"daily?"];
    query = [query stringByAppendingFormat:@"&lat=%f", location.coordinate.latitude];
    query = [query stringByAppendingFormat:@"&lon=%f", location.coordinate.longitude];
    query = [query stringByAppendingFormat:@"&cnt=%d", 10];
    
    NSArray *jsonResponse = [[[WeatherWebservice apiQuery:query] objectForKey:@"list"] allObjects];
    NSMutableArray *weekWeather = [[NSMutableArray alloc] init];
    
    if (!jsonResponse) {
        NSLog(@"Error parsing JSON");
    } else {
        int index = 0;
        for(NSDictionary * dic in jsonResponse) {
            Weather* weather = [[Weather alloc] init];
            weather.temperature = [self kelvinToCelsius:[[[[jsonResponse objectAtIndex:index] objectForKey:@"temp"] objectForKey:@"day"] floatValue]];
            weather.humidity = [[[jsonResponse objectAtIndex:index] objectForKey:@"humidity"] floatValue];
            weather.pressure = [[[jsonResponse objectAtIndex:index] objectForKey:@"pressure"] intValue];
            weather.iconName = [[[[jsonResponse objectAtIndex:index] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
            weather.day = [NSDate dateWithTimeIntervalSince1970:([[[jsonResponse objectAtIndex:index] objectForKey:@"dt"] longValue])];
            [weekWeather insertObject:weather atIndex:index++];
        }
    }
    
    return weekWeather;
}

- (float) kelvinToCelsius:(float) kelvin
{
    return kelvin - 273.15;
}

@end
