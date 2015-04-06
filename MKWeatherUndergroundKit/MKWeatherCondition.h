//
//  MKWeatherCondition.h
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "Climacons.h"


////////////////////////////////////////////////////
////////////////// COMMON TYPES ////////////////////
////////////////////////////////////////////////////
@interface MKTemperature : NSObject<NSCoding>
@property (nonatomic)double f;
@property (nonatomic)double c;
@end

@interface MKDistance : NSObject<NSCoding>
@property (nonatomic) double kph;
@property (nonatomic) double mph;
@end

@interface MKWindDirection : NSObject<NSCoding>
@property (nonatomic, strong) NSString *direction;
@property (nonatomic) double degrees;
@end
/////////////////////////////////////////////////////


/**
 MKWeatherCondition represents a generic weather condition
 */
@interface MKWeatherCondition : NSObject<NSCoding>

// -----
// @name Properties
// -----
#pragma mark - Properties

/**
 Name of the icon (For custom fonts)
 */
@property (nonatomic, strong)NSString *iconName;

/**
 Temperature
 
 Returns nil if temperature is not available (i.e. Requesting future conditions)
 
 */
@property (nonatomic, strong)MKTemperature *temperature;


/**
 Word or phrase describing the conditions.
 
 (e.g. 'Clear', 'Rain', etc.)
 
 */
@property (nonatomic, strong)NSString *summary;


/**
 URL for retrieving the icon image
 */
@property (nonatomic, strong)NSURL *iconImageURL;

/**
 Date of the weather conditions represented.
 */
@property (nonatomic, strong)NSDate *date;

/**
 Weather icon matching weather conditions
 */
@property (nonatomic) Climacon climacon;

/**
 High temperature
 */
@property (nonatomic, strong) MKTemperature *highTemp;

/**
 Low temperature
 */
@property (nonatomic, strong) MKTemperature *lowTemp;

/**
 Humidity
 */
@property (nonatomic, strong)NSString *humudity;

/**
 Dew point temperature
 */
@property (nonatomic, strong)MKTemperature *dewPoint;

/**
 Wind speed
 */
@property (nonatomic, strong)MKDistance *windSpeed;

/**
 Time last updated.
 */
@property (nonatomic, strong)NSString *lastUpdated;

/**
 Relative humidity
 */
@property (nonatomic, strong)NSString *relativeHumidity;

/**
 Feels like temperature
 */
@property (nonatomic, strong)MKTemperature *feelsLike;


/**
 Visibility distance
 */
@property (nonatomic, strong)MKDistance *visibility;

/**
 Barometric pressure
 */
@property (nonatomic)double pressure_inches;

/**
 UV index
 */
@property (nonatomic)NSUInteger UVIndex;

/**
 Wind gust
 */
@property (nonatomic, strong)MKDistance *windGust;

/**
 Wind direction
 */
@property (nonatomic, strong)MKWindDirection *windDirection;

/**
 Short summary of wind conditions
 */
@property (nonatomic, strong)NSString *windSummary;

/**
 Windchill
 */
@property (nonatomic, strong)MKTemperature *windChill;

/**
 Day title
 
 e.g 'Monday', 'Monday night'...
 
 Available only when requesting full summaries
 */
@property (nonatomic, strong) NSString *generalTimeOfDayTitle;

/**
 Full summary in Farenheit format
 
 e.g. "Sunshine and clouds mixed. High 28F. Winds WNW at 15 to 25 mph. Winds could occasionally gust over 40 mph."
 
 Available only when requesting full summaries
 */
@property (nonatomic, strong) NSString *fullSummaryF;

/**
 Full summary in Celsius format
 
 e.g. "A mix of clouds and sun. High -1C. Winds WNW at 15 to 30 km/h."
 
 Available only when requesting full summaries
 */
@property (nonatomic, strong) NSString *fullSummaryC;


/**
 */
@property (nonatomic)NSInteger averageHumudity;

@end
