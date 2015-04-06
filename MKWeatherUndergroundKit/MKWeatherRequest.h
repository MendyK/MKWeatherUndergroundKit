//
//  MKWeatherRequest.h
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.

#pragma mark - Imports
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#pragma mark - Type defs
/**
 Completion handler block type for requests.
 
 @param completionHandler completion block
 */
typedef void (^MKWeatherRequestCompletion) (NSError *error, id responseObject);

/**
 Request types.
 */
typedef NS_ENUM(NSInteger, MKWeatherRequestType)
{
    /** Returns NSArray of MKWeatherCondition objects */
    MKWeatherRequestTypeHourly               = 1 << 0,
    /** Returns NSArray of MKWeatherCondition objects */
    MKWeatherRequestTypeCurrentConditions    = 1 << 1 ,
    MKWeatherRequestType10DayForecast        = 1 << 2,
    MKWeatherRequestType3DayForecast         = 1 << 3,
    MKWeatherRequestType3DayForecastSummary  = 1 << 4,
};


extern NSString *const MKWeatherRequestErrorDomain;

typedef NS_ENUM(NSInteger, MKWeatherRequestError)
{
    /** Data parsing failed */
    MKWeatherRequestParsingError = 1,
    
    /** Request type not specified */
    MKWeatherRequestTypeError  = 2
};
#pragma mark - Interface

/**
 MKWeatherRequest completes requests to the Weather Underground API. Requests can return data regarding
 both the current conditions and future conditions for any given location
 */
@interface MKWeatherRequest : NSObject

// -----
// @name Properties
// -----

#pragma mark - Properties

/**
 
 The type of request
  
 This must be specified before performing a request
 */
@property (nonatomic)MKWeatherRequestType requestType;

/**
 
 Language in which the data should be returned
 
*/
@property (nonatomic, strong)NSString *language;


/**
 The location of the request
 */
@property (nonatomic, strong)CLLocation *location;

// -----
// @name Weather Request Initializers
// -----

#pragma mark - Weather Request Initializers

/**
 
 Creates a new request object
 
 @param requestType The type of request
 @param location Location of request
 @return Newly initialized request object.

 */
+ (instancetype)requestWithType: (MKWeatherRequestType)requestType location: (CLLocation *)location;

/**
 
 Creates a new request object
 
 @param requestType the Request type
 @return Newly initialized request object.
 
 */
+ (instancetype)requestWithType: (MKWeatherRequestType)requestType;

/**
 Creates a new request object
 
 @param type the type of request
 @param location Location of request
 @return Newly initialized request object.
*/
- (instancetype)initWithType: (MKWeatherRequestType)type location: (CLLocation *)loc;

// -----
// @name Performing a Weather Request
// -----

#pragma mark - Performing a Weather Request

/** Performs an asyncronus weather request.
 
 @param completionHandler The handler to be executed upon completion. Will be executed on the main thread
 */
- (void)performRequestWithHandler: (MKWeatherRequestCompletion)completionHandler;

@end

