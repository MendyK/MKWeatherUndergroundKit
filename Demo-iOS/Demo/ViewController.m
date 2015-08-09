//
//  ViewController.m
//  Demo
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//

#import "ViewController.h"
#import "MKWUndergroundKit.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *climaconLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CLGeocoder *geocoder = [CLGeocoder new];
    
    __weak typeof(self)weakSelf = self;
    [geocoder geocodeAddressString:self.locationToSearch completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestTypeCurrentConditions
                                                             location:placemark.location];
        request.weatherUndergroundApiKey = @"API_KEY_HERE";
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
                NSLog(@"%@", [error localizedRecoverySuggestion]);
            }
            MKWeatherCondition *current = responseObject;
            weakSelf.climaconLabel.text = [NSString stringWithFormat:@"%c",
                                   current.climacon];
            
            weakSelf.summaryLabel.text = [NSString stringWithFormat:@"%@", current.summary];
            weakSelf.location.text = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
            weakSelf.tempLabel.text = [NSString stringWithFormat:@"%i°",(int) current.temperature.f];
        }];
    }];
    
    
}

@end
