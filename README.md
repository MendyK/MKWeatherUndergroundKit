# MKWeatherUndergroundKit
A simple iOS and OS X library for retrieving weather information using the Weather Underground API


## Getting Started

You'll need a [Weather Underground API key](http://www.wunderground.com/weather/api/) to start.

### Getting the Current Conditions
````smalltalk
    //Get the location
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:@"New York" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        //Initialize request
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestTypeCurrentConditions
                                                             location:placemark.location];
        request.weatherUndergroundApiKey = @"API_KEY_HERE";
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
        request.weatherUndergroundApiKey = @"API_KEY_HERE";
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            NSArray *hours = responseObject;
            //Array of MKWeatherCondition Objects
        }];
    }];
````
### Getting the forecast for the next 3 days
 
````smalltalk
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:@"London, England" completionHandler:^(NSArray *placemarks, NSError *error)     {
        CLPlacemark *placemark = [placemarks firstObject];
        
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestType3DayForecast
                                                             location:placemark.location];
        request.weatherUndergroundApiKey = @"API_KEY_HERE";
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            NSArray *threeDayForecast = responseObject;
            //Here responseObject is an array that contains 4 objects: tonight, and the next three days.

            MKWeatherCondition *tonightsConditions = [threeDayForecast firstObject];
            
            NSLog(@"%f", tonightsConditions.highTemp.c);
            NSLog(@"%f", tonightsConditions.lowTemp.c);
            NSLog(@"%ld", (long)tonightsConditions.averageHumudity);
            
        }];
    }];
````

### Getting  a small forecast summary for the next 3 days 
````smalltalk
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:@"New Mexico" completionHandler:^(NSArray *placemarks, NSError *error)     {
        CLPlacemark *placemark = [placemarks firstObject];
        
        MKWeatherRequest *request = [MKWeatherRequest requestWithType:MKWeatherRequestType3DayForecastSummary
                                                             location:placemark.location];
        request.weatherUndergroundApiKey = @"API_KEY_HERE";
        [request performRequestWithHandler:^(NSError *error, id responseObject) {
            NSArray *threeDayForecast = responseObject;
            //Here responseObject is an array which contains 8 objects
            
            MKWeatherCondition *condition = [threeDayForecast firstObject];
            NSLog(@"%@", condition.generalTimeOfDayTitle);
            NSLog(@"%@", condition.fullSummaryC);
            NSLog(@"%@", condition.fullSummaryF);
            
        }];
    }];
````

### Climacons

`MKWeatherCondition` objects have a `climacon` property that contains an appropriate climacon character mapping for the weather condition description. The [Climacons Font](http://adamwhitcroft.com/climacons/font/) is a font set created by [Adam Whitcroft](http://adamwhitcroft.com/) featuring various weather-related icons. In order to use the `climacon` property, download the Climacons font and add it to your project. 

## Dependencies
This library uses `Core Location` to perform requests.

## Architecture
`MKWeatherCondition` - A generic weather condition

`MKWeatherParser` - Parses the weather information received from the Weather Underground API

`MKWeatherRequest` - Represents a single request to the Weather Underground API
## CocoaPods

To use this with CocoaPods, add `pod 'MKWeatherUndergroundKit'` to your podfile

## Thanks
[Kevin Mindeguia](https://github.com/KMindeguia) for the NSDictionary/NSArray categories.

[Comyar Zaheri](https://github.com/comyarzaheri) for the `Climacons.h` file and the `Climacons` description.

## License
See the `License` file
