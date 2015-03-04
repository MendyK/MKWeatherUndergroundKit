# MKWeatherUndergroundKit
A simple Cocoa/Cocoa Touch library for retrieving weather information using the Weather Underground API


##Getting Started

###Climacons
Thanks to [Comyar Zaheri](http://comyar.io) for the `Climacons.h` file, as well as the description below.


`MKWeatherCondition` objects have a `climacon` property that contains an appropriate climacon character mapping for the weather condition description. The [Climacons Font](http://adamwhitcroft.com/climacons/font/) is a font set created by [Adam Whitcroft](http://adamwhitcroft.com/) featuring various weather-related icons. In order to use the `climaconCharacter` property, download the Climacons font and add it to your project. 

###Getting the Current Conditions
````smalltalk
    //Get the location
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:@"New York" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        //Initialize request
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestTypeCurrentConditions
                                                             location:placemark.location];
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            MKWeatherCondition *currentConditions = responseObject;
            //Use currentConditions object here
        }];
    }];
  
````
### Getting the forecast for the next 36 hours
````smalltalk
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:@"San Francisco" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestTypeHourly
                                                             location:placemark.location];
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            NSArray *hours = responseObject;
            //Array of MKWeatherCondition Objects
        }];
    }];
    
  
````
##Dependencies
Core Location

##License
This project is under the MIT License
