//
//  MKWeatherRequest.m
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.

#import "MKWeatherRequest.h"
#import "MKWeatherParser.h"

NSString *const kWUndergroundApi_key = @"INSERT API KEY HERE";
NSString *const kBaseURL = @"http://api.wunderground.com/api";
NSString *const MKWeatherRequestErrorDomain = @"MKWeatherRequestErrorDomain";

@interface MKWeatherRequest()

@end
@implementation MKWeatherRequest

#pragma mark - Initializers
- (instancetype)initWithType: (MKWeatherRequestType)type location: (CLLocation *)location
{
    if (self = [super init]) {
        _location = location;
        _requestType = type;
    }
    return self;
}
- (instancetype)init
{
    return [self initWithType:NAN location:nil];
}
+ (instancetype)requestWithType: (MKWeatherRequestType)requestType location: (CLLocation *)location
{
    return [[self alloc]initWithType:requestType location:location];
}
+ (instancetype)requestWithType: (MKWeatherRequestType)requestType
{
    return [[self alloc]initWithType:requestType location:nil];
}

#pragma mark - Requests
- (void)performRequestWithHandler: (MKWeatherRequestCompletion)completionHandler
{
    NSURL *requestURL = [self urlForRequestType:self.requestType];
    if (!requestURL) {
        completionHandler ([NSError errorWithDomain:MKWeatherRequestErrorDomain
                                               code:MKWeatherRequestTypeError
                                           userInfo:nil], nil);
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.timeoutInterval = 60.0;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
        if (data){
        MKWeatherParser *parser = [[MKWeatherParser alloc]initWithType:self.requestType];
        
        id weatherObject = [parser parseJson:[self JSONDictFromResponseData:data]];
            if (weatherObject) {
                completionHandler (nil, weatherObject);
            }
            else{
                completionHandler([NSError errorWithDomain:MKWeatherRequestErrorDomain
                                                      code:MKWeatherRequestParsingError
                                                  userInfo:nil], weatherObject);
            }
        }
        else{
            completionHandler (connectionError, nil);
        }
    }];
}

- (NSURL *)urlForRequestType: (MKWeatherRequestType)requestType
{
    NSString *requestTypeString;
    
    switch (self.requestType) {
        case MKWeatherRequestType10DayForecast:
            requestTypeString = @"forecast10day";
            break;
        case MKWeatherRequestTypeCurrentConditions:
            requestTypeString = @"conditions";
            break;
        case MKWeatherRequestType3DayForecast:
        case MKWeatherRequestType3DayForecastSummary:
            requestTypeString = @"forecast";
            break;
        case MKWeatherRequestTypeHourly:
            requestTypeString = @"hourly";
            break;
        default:
            return nil;
    }
    CLLocationCoordinate2D coords = self.location.coordinate;
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/",kBaseURL,kWUndergroundApi_key, requestTypeString];
    if ([self.language length] > 0) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"lang:%@/",self.language]];
    }
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"q/%f,%f,.json",coords.latitude, coords.longitude]];
    
    return [NSURL URLWithString:urlString];
}
- (id)JSONDictFromResponseData: (NSData *)data
{
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    return JSON;
}
@end
