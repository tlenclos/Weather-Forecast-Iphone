//
//  SecondViewController.m
//  Weather forecast
//
//  Created by Thibault Lenclos on 09/01/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import "SecondViewController.h"
#import "WeatherWebservice.h"
#import "Weather.h"
#import "User.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.weatherWeek = [[NSMutableArray alloc] init];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.];;
    self.tableView.backgroundColor = [UIColor colorWithRed:47/255. green:140/255. blue:205/255. alpha:1.];
}

- (void) viewWillAppear:(BOOL)animated
{
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    if ([reach isReachable]) {
        // Get week meteo data
        dispatch_queue_t myQueue = dispatch_queue_create("Get week meteo",NULL);
        dispatch_async(myQueue, ^{
            
            User* user = [User sharedInstance];
            WeatherWebservice* ws = [[WeatherWebservice alloc] init];
            _weatherWeek = [ws getWeekWeatherForLocation:[user location]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self.tableView reloadData];
            });
        });
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"No internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // Call alert
        [errorAlert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _weatherWeek.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Weather* weather = [_weatherWeek objectAtIndex:indexPath.row];

    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE dd MMMM"];
    cell.textLabel.text = [dateFormatter stringFromDate:weather.day];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02fF° / %d Pa", weather.temperature, weather.pressure];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", weather.iconName]];
    
    [cell contentView].backgroundColor = (indexPath.row%2)
        ? [UIColor colorWithRed:47/255. green:140/255. blue:205/255. alpha:1.]
        : [UIColor colorWithRed:67/255. green:160/255. blue:225/255. alpha:0.9]
    ;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}



@end
