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

- (void)viewDidLoad {
    [super viewDidLoad];

    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:self.locationToSearch completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestTypeCurrentConditions
                                                             location:placemark.location];
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            
            MKWeatherCondition *current = responseObject;
            _climaconLabel.text = [NSString stringWithFormat:@"%c",
                                   current.climacon];
            
            _summaryLabel.text = [NSString stringWithFormat:@"%@", current.summary];
            _location.text = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality, placemark.administrativeArea, placemark.country];
            _tempLabel.text = [NSString stringWithFormat:@"%i°",(int) current.temperature.f];
        }];
    }];
    
    
}

@end
