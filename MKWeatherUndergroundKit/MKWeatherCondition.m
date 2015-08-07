//
//  MKWeatherCondition.m
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.

#import "MKWeatherCondition.h"

#pragma mark - MKTemperature implementation

@implementation MKTemperature;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _f = [coder decodeDoubleForKey:@"mk_farenheit"];
        _c = [coder decodeDoubleForKey:@"mk_celsius"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.f forKey:@"mk_farenheit"];
    [aCoder encodeDouble:self.c forKey:@"mk_celsius"];
}

@end

#pragma mark - MKDistance implementation

@implementation MKDistance;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _mph = [coder decodeDoubleForKey:@"mk_mph"];
        _kph = [coder decodeDoubleForKey:@"mk_kph"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.mph forKey:@"mk_mph"];
    [aCoder encodeDouble:self.kph forKey:@"mk_kph"];
}
@end

#pragma mark - MKWindDirection implementation

@implementation MKWindDirection

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.direction = [coder decodeObjectForKey:@"mk_direction"];
        self.degrees = [coder decodeDoubleForKey:@"mk_degrees"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.direction forKey:@"mk_direction"];
    [aCoder encodeDouble:self.degrees forKey:@"mk_degrees"];
}
@end

#pragma mark - MKWeatherCondition implementation

@implementation MKWeatherCondition

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _iconName               = [coder decodeObjectForKey:@"mk_iconName"];
        _temperature            = [coder decodeObjectForKey:@"mk_temperature"];
        _summary                = [coder decodeObjectForKey:@"mk_summary"];
        _iconImageURL           = [coder decodeObjectForKey:@"mk_iconImageURL"];
        _date                   = [coder decodeObjectForKey:@"mk_date"];
        _climacon               = [[coder decodeObjectForKey:@"mk_climacon"]charValue];
        _highTemp               = [coder decodeObjectForKey:@"mk_highTemp"];
        _lowTemp                = [coder decodeObjectForKey:@"mk_lowTemp"];
        _humudity               = [coder decodeObjectForKey:@"mk_humudity"];
        _dewPoint               = [coder decodeObjectForKey:@"mk_dewPoint"];
        _windSpeed              = [coder decodeObjectForKey:@"mk_windSpeed"];
        _lastUpdated            = [coder decodeObjectForKey:@"mk_lastUpdated"];
        _relativeHumidity       = [coder decodeObjectForKey:@"mk_relativeHumidity"];
        _feelsLike              = [coder decodeObjectForKey:@"mk_feelsLike"];
        _visibility             = [coder decodeObjectForKey:@"mk_visibility"];
        _pressure_inches        = [coder decodeDoubleForKey:@"mk_pressure_inches"];
        _UVIndex                = [coder decodeIntegerForKey:@"mk_UVIndex"];
        _windGust               = [coder decodeObjectForKey:@"mk_windGust"];
        _windDirection          = [coder decodeObjectForKey:@"mk_windDirection"];
        _windSummary            = [coder decodeObjectForKey:@"mk_windSummary"];
        _windChill              = [coder decodeObjectForKey:@"mk_windChill"];
        _generalTimeOfDayTitle  = [coder decodeObjectForKey:@"mk_generalTimeOfDayTitle"];
        _fullSummaryF           = [coder decodeObjectForKey:@"mk_fullSummaryF"];
        _fullSummaryC           = [coder decodeObjectForKey:@"mk_fullSummaryC"];
        _averageHumudity        = [coder decodeIntegerForKey:@"mk_averageHumudity"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.iconName forKey:@"mk_iconName"];
    [aCoder encodeObject:self.temperature forKey:@"mk_temperature"];
    [aCoder encodeObject:self.summary forKey:@"mk_summary"];
    [aCoder encodeObject:self.iconImageURL forKey:@"mk_iconImageURL"];
    [aCoder encodeObject:self.date forKey:@"mk_date"];
    [aCoder encodeObject:[NSNumber numberWithChar:self.climacon] forKey:@"mk_climacon"];
    [aCoder encodeObject:self.highTemp forKey:@"mk_highTemp"];
    [aCoder encodeObject:self.lowTemp forKey:@"mk_lowTemp"];
    [aCoder encodeObject:self.humudity forKey:@"mk_humudity"];
    [aCoder encodeObject:self.dewPoint forKey:@"mk_dewPoint"];
    [aCoder encodeObject:self.windSpeed forKey:@"mk_windSpeed"];
    [aCoder encodeObject:self.lastUpdated forKey:@"mk_lastUpdated"];
    [aCoder encodeObject:self.relativeHumidity forKey:@"mk_relativeHumidity"];
    [aCoder encodeObject:self.feelsLike forKey:@"mk_feelsLike"];
    [aCoder encodeObject:self.visibility forKey:@"mk_visibility"];
    [aCoder encodeDouble:self.pressure_inches forKey:@"mk_pressure_inches"];
    [aCoder encodeInteger:self.pressure_inches forKey:@"mk_pressure_inches"];
    [aCoder encodeObject:self.windGust forKey:@"mk_windGust"];
    [aCoder encodeObject:self.windDirection forKey:@"mk_windDirection"];
    [aCoder encodeObject:self.windSummary forKey:@"mk_windSummary"];
    [aCoder encodeObject:self.windChill forKey:@"mk_windChill"];
    [aCoder encodeObject:self.generalTimeOfDayTitle forKey:@"mk_generalTimeOfDayTitle"];
    [aCoder encodeObject:self.fullSummaryF forKey:@"mk_fullSummaryF"];
    [aCoder encodeObject:self.fullSummaryC forKey:@"mk_fullSummaryC"];
    [aCoder encodeInteger:self.averageHumudity forKey:@"mk_averageHumudity"];
}

@end
