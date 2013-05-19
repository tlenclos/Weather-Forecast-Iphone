//
//  SecondViewController.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 09/01/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "SecondViewController.h"
#import "Weather.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    
    Weather *weatherHelper = [Weather alloc];
    [weatherHelper getTodayWeather];
    NSLog(@"Humidity = %f", [weatherHelper humidity]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
