//
//  SecondViewController.h
//  Weather forecast
//
//  Created by Thibault Lenclos on 09/01/13.
//  Copyright (c) 2013 Thibault Lenclos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController  : UITableViewController

@property (strong, nonatomic) IBOutlet NSMutableArray* weatherWeek;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
