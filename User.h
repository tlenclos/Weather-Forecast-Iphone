//
//  User.h
//  Weather forecast
//
//  Created by Thibault Lenclos on 22/06/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface User : NSObject

@property (readwrite, copy) CLLocation* location;

+ (id)sharedInstance;
@end