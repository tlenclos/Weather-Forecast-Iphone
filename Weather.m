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
    
    // Create request, url connection and fire request
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kAPIAddress,query];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection *conn = [[NSURLConnection alloc] init];
    (void)[conn initWithRequest:request delegate:self];

    return true;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connectionwillCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSDictionary* jsonDictionnary = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
    NSArray *jsonResponse = [[jsonDictionnary objectForKey:@"list"] allObjects];
    
    if (!jsonResponse) {
        NSLog(@"Error parsing JSON");
    } else {
        NSLog(@"JSON: %@", [jsonResponse objectAtIndex:0]);
        
        place = [[[jsonResponse objectAtIndex:0] objectForKey:@"name"] stringValue];
        temperature = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        humidity = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"humidity"] floatValue];
        windSpeed = [[[[jsonResponse objectAtIndex:0] objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
        pressure = [[[[jsonResponse objectAtIndex:0] objectForKey:@"main"] objectForKey:@"pressure"] intValue];
        
        // TODO : Call to update view
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
