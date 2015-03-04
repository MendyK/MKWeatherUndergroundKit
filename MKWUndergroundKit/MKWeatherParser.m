//
//  MKWeatherParser.m
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.

#pragma mark - Imports

#import "MKWeatherParser.h"
#import "MKWeatherCondition.h"
#import "Climacons.h"
#import "NSString+Reversal.h"

/** 
 Check if given option is present.
 */
#define OptionPresent(options, value) (((options & (value)) == (value))

#pragma mark - Implementation

@implementation MKWeatherParser
#pragma mark - Initializers
- (instancetype)initWithType:(MKWeatherRequestType)parsingType
{
    if (self = [super init]) {
        _parsingType = parsingType;
    }
    return self;
}
#pragma mark - Parsing
- (id)parseJson: (id)JSON
{
//    [self printNumber:self.parsingType];
    
    if (OptionPresent(self.parsingType, MKWeatherRequestType10DayForecast)))
    {
        return [self parse10DayForecastWithJSON: JSON];
    }
    else if (OptionPresent(self.parsingType, MKWeatherRequestType3DayForecast)))
    {
        return [self parse3DayWeatherForecastWithJSON:JSON];
    }
    else if (OptionPresent(self.parsingType, MKWeatherRequestType3DayForecastSummary)))
    {
        return [self parse3DaySummariesWithJSON:JSON];
    }
    else if (OptionPresent(self.parsingType, MKWeatherRequestTypeCurrentConditions)))
    {
        return [self parseCurrentWeatherConditionsWithJSON:JSON];
    }
    else if (OptionPresent(self.parsingType, MKWeatherRequestTypeHourly)))
    {
        return [self parseHourlyDataWithJSON:JSON];
    }
    else if (OptionPresent(self.parsingType, MKWeatherRequestType3DayForecast))
        && OptionPresent(self.parsingType, MKWeatherRequestType3DayForecast)))
    {
        //need to implement
    }
    return nil;
}

#pragma mark Specific Types
- (NSArray *)parse10DayForecastWithJSON:(id) JSON
{
    NSDictionary *forecast = JSON[@"forecast"];
    if (!forecast) {
        return nil;
    }
    NSArray *simpleForecastDay = forecast[@"simpleforecast"][@"forecastday"];
    
    NSMutableArray *tempDayArray = [NSMutableArray array];
    for (NSDictionary *day in simpleForecastDay) {
        MKWeatherCondition *condition = [[MKWeatherCondition alloc]init];
        condition.date = [NSDate new];
        condition.date = [NSDate dateWithTimeIntervalSince1970:[day[@"date"][@"epoch"]integerValue]];
        condition.summary = day[@"conditions"];
        condition.iconImageURL = day [@"icon_url"];
        condition.iconName = day[@"icon"];
        
        condition.highTemp = [MKTemperature new];
        condition.lowTemp = [MKTemperature new];
        condition.highTemp.f = [day[@"high"][@"fahrenheit"]floatValue];
        condition.highTemp.c = [day[@"high"][@"celsius"]floatValue];
        condition.lowTemp.f = [day[@"low"][@"fahrenheit"]floatValue];
        condition.lowTemp.c = [day[@"low"][@"celsius"]floatValue];
        
        [tempDayArray addObject:condition];
    }
    return [tempDayArray copy];
}
- (NSArray *)parse10DaySummariesWithJson: (id) summaries
{
    return nil;
}
- (MKWeatherCondition *)parseCurrentWeatherConditionsWithJSON: (id)JSON
{
    NSDictionary *weatherDict = JSON[@"current_observation"];
    if (!weatherDict) {
        return nil;
    }
    MKWeatherCondition *currentWeather = [MKWeatherCondition new];
    
    NSDictionary *locationInfo = weatherDict[@"display_location"];
    
    currentWeather.temperature = [MKTemperature new];
    currentWeather.windChill = [MKTemperature new];
    currentWeather.windGust = [MKDistance new];
    currentWeather.windSpeed = [MKDistance new];
    currentWeather.windDirection = [MKWindDirection new];
    currentWeather.dewPoint = [MKTemperature new];
    currentWeather.feelsLike = [MKTemperature new];
    currentWeather.visibility = [MKDistance new];

    currentWeather.lastUpdated = locationInfo[@"observation_time"];
    currentWeather.date = [NSDate dateWithTimeIntervalSince1970:[weatherDict[@"observation_epoch"]integerValue]];
    currentWeather.summary = weatherDict[@"weather"];
    currentWeather.temperature.f = [weatherDict[@"temp_f"]floatValue];
    currentWeather.temperature.c = [weatherDict[@"temp_c"]floatValue];
    currentWeather.relativeHumidity = weatherDict[@"relative_humidity"];
    currentWeather.dewPoint.f = [weatherDict [@"dewpoint_f"]floatValue];
    currentWeather.dewPoint.c = [weatherDict [@"dewpoint_c"]floatValue];
    currentWeather.feelsLike.f = [weatherDict [@"feelslike_f"]floatValue];
    currentWeather.feelsLike.c = [weatherDict [@"feelslike_c"]floatValue];
    currentWeather.visibility.mph = [weatherDict[@"visibility_mi"]floatValue];
    currentWeather.visibility.kph = [weatherDict[@"visibility_km"]floatValue];
    currentWeather.pressure_inches = [weatherDict[@"pressure_in"]floatValue];
    currentWeather.windSummary = weatherDict[@"wind_string"];
    currentWeather.windDirection.direction = weatherDict[@"wind_dir"];
    currentWeather.windDirection.degrees = [weatherDict[@"wind_degrees"]doubleValue];
    currentWeather.windSpeed.mph = [weatherDict[@"wind_mph"]floatValue];
    currentWeather.windSpeed.kph = [weatherDict[@"wind_kph"]floatValue];
    currentWeather.windGust.mph = [weatherDict[@"wind_gust_mph"]floatValue];
    currentWeather.windGust.kph = [weatherDict[@"wind_gust_kph"]floatValue];
    currentWeather.windChill.f = [weatherDict [@"windchill_f"]floatValue];
    currentWeather.windChill.c = [weatherDict [@"windchill_c"]floatValue];
    currentWeather.UVIndex = [weatherDict[@"UV"]integerValue];
    currentWeather.iconName = weatherDict[@"icon"];
    currentWeather.iconImageURL = [NSURL URLWithString:weatherDict[@"icon_url"]];
    currentWeather.climacon = [self climaconForIconLink:weatherDict[@"icon_url"] name:currentWeather.iconName];
    return currentWeather;
}

- (NSArray *)parseHourlyDataWithJSON: (id)JSON
{
    NSArray *hourlyForecasts = JSON[@"hourly_forecast"];
    if (!hourlyForecasts) {
        return nil;
    }
    
    NSMutableArray *hourlyWeatherComponents = [NSMutableArray array];
    for (NSDictionary *hour in hourlyForecasts)
    {
        MKWeatherCondition *component = [MKWeatherCondition new];
        
        //hourlyTemp
        NSDictionary *tempStrings = hour[@"temp"];
        component.temperature = [MKTemperature new];
        component.dewPoint = [MKTemperature new];
        component.windSpeed = [MKDistance new];
        component.humudity = [NSString new];

        component.temperature.f = [tempStrings[@"english"]doubleValue];
        component.temperature.c = [tempStrings[@"metric"]doubleValue];
        component.date = [NSDate dateWithTimeIntervalSince1970:[hour[@"FCTTIME"][@"epoch"]integerValue]];
        component.iconName = [NSString stringWithFormat:@"%@",hour[@"icon"]];
        component.summary = hour[@"condition"];
        component.iconImageURL = [NSURL URLWithString:hour[@"icon_url"]];
        component.climacon = [self climaconForIconLink:hour[@"icon_url"] name:component.iconName];
        component.dewPoint.f = [hour[@"dewpoint"][@"english"]floatValue];
        component.dewPoint.c = [hour[@"dewpoint"][@"metric"]floatValue];
        component.windSpeed.mph = [hour[@"wspd"][@"english"]floatValue];
        component.windSpeed.kph = [hour[@"wspd"][@"metric"]floatValue];
        component.humudity = hour[@"humidity"];
        [hourlyWeatherComponents addObject:component];
    }
    return hourlyWeatherComponents;
}
- (NSArray *)parse3DayWeatherForecastWithJSON: (id) JSON
{
    NSDictionary *forecast = JSON[@"forecast"];
    if (!forecast) {
        return nil;
    }
    //simple forecast
    NSDictionary *simpleForecast  = forecast[@"simpleforecast"];
    NSArray *dayForecast = simpleForecast [@"forecastday"];
    
    NSMutableArray *tempDays = [NSMutableArray array];
    for (NSDictionary *day in dayForecast) {
        MKWeatherCondition *component = [MKWeatherCondition new];
        component.highTemp = [MKTemperature new];
        component.lowTemp = [MKTemperature new];
        
        component.highTemp.f = [day[@"high"][@"fahrenheit"]floatValue];
        component.highTemp.c = [day[@"high"][@"celsius"]floatValue];
        component.lowTemp.f = [day[@"low"][@"fahrenheit"]floatValue];
        component.lowTemp.c = [day[@"low"][@"celsius"]floatValue];
        component.averageHumudity = [day[@"avehumidity"]integerValue];
        component.iconName = day[@"icon"];
        component.iconImageURL = [NSURL URLWithString:day[@"icon_url"]];
        component.summary = day[@"conditions"];
        component.date = [NSDate dateWithTimeIntervalSince1970:[day[@"date"][@"epoch"]integerValue]];
        component.climacon = [self climaconForIconLink:day[@"icon_url"] name:component.iconName];
        [tempDays addObject:component];
    }
    return tempDays;
}
- (NSArray *)parse3DaySummariesWithJSON: (id) summaries
{
    NSDictionary *forecast = summaries[@"forecast"];
    if (!forecast) {
        return nil;
    }
    //"txt_forecast"
    NSDictionary *summaryForecast = forecast[@"txt_forecast"];
    NSArray *dayNightForecast = summaryForecast[@"forecastday"];
    
    NSMutableArray *tempSummary = [NSMutableArray array];
    for (NSDictionary *dayOrNight in dayNightForecast) {
        MKWeatherCondition *component = [MKWeatherCondition new];
        component.fullSummaryF = dayOrNight [@"fcttext"];
        component.fullSummaryC = dayOrNight [@"fcttext_metric"];
        component.generalTimeOfDayTitle = dayOrNight [@"title"];
        [tempSummary addObject:component];
    }
    return tempSummary;
}
#pragma mark - Climacons
- (Climacon)climaconForIconLink:(NSString *)link name: (NSString *)name
{
    Climacon icon;
    
    //check to see if its nighttime
    NSString *reversed = [link mk_reverseString:link];
    NSRange rangeToDash = [reversed rangeOfString:@"/"];
    NSString *sub = [reversed substringToIndex:rangeToDash.location];
    BOOL isNightTime = [sub hasSuffix:@"tn"];
    
    if ([name localizedCaseInsensitiveContainsString:@"sunny"])
        icon = ClimaconSun;
    else if ([name localizedCaseInsensitiveContainsString:@"Clear"])
        icon = isNightTime ? ClimaconMoon : ClimaconSun;
    else if ([name localizedCaseInsensitiveContainsString:@"cloud"])
        icon = isNightTime ? ClimaconCloudMoon : ClimaconCloud;
    else if ([name localizedCaseInsensitiveContainsString:@"rain"])
        icon = isNightTime ? ClimaconRainMoon : ClimaconRain;
    else if ([name localizedCaseInsensitiveContainsString:@"tstorms"])
        icon = isNightTime ? ClimaconDownpourMoon : ClimaconDownpour;
    else if ([name localizedCaseInsensitiveContainsString:@"fog"])
        icon = isNightTime ? ClimaconFogMoon : ClimaconFog;
    else if ([name localizedCaseInsensitiveContainsString:@"hazy"])
        icon = isNightTime ? ClimaconHazeMoon : ClimaconHaze;
    else if ([name localizedCaseInsensitiveContainsString:@"sleet"])
        icon = isNightTime ? ClimaconSleetMoon : ClimaconSleet;
    else if ([name localizedCaseInsensitiveContainsString:@"Snow"])
        icon = isNightTime ? ClimaconSnowMoon : ClimaconSnow;
    else if ([name localizedCaseInsensitiveContainsString:@"flurries"])
        icon = isNightTime ? ClimaconFlurriesMoon : ClimaconFlurries;
    else
        icon = ClimaconSun;
    
    /* More - http://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary&MR=1#current_condition_phrases */
    return icon;
}
@end
