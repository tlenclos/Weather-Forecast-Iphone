//
//  User.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 22/06/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize location;

static User *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (User *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}

@end