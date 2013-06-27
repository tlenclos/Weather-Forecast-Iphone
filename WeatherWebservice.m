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
    
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingAllowFragments error:nil];
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
    
    NSArray *jsonResponse = [[[WeatherWebservice apiQuery:query] objectForKey:@"list"] allObjects];
    
    if (!jsonResponse) {
        NSLog(@"Error parsing JSON");
    } else {
        weather.place = [[jsonResponse objectAtIndex:0] objectForKey:@"name"];
        weather.temperature = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] floatValue];
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
            NSLog(@"JSON: %@", [jsonResponse objectAtIndex:0]);
            Weather* weather = [[Weather alloc] init];
            weather.temperature = [[[jsonResponse objectAtIndex:index] objectForKey:@"deg"] floatValue];
            weather.humidity = [[[jsonResponse objectAtIndex:index] objectForKey:@"humidity"] floatValue];
            weather.pressure = [[[jsonResponse objectAtIndex:index] objectForKey:@"pressure"] intValue];
            weather.iconName = [[[[jsonResponse objectAtIndex:index] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
            weather.day = [NSDate dateWithTimeIntervalSince1970:([[[jsonResponse objectAtIndex:index] objectForKey:@"dt"] longValue])];
            [weekWeather insertObject:weather atIndex:index++];
        }
    }
    
    return weekWeather;
}


@end
