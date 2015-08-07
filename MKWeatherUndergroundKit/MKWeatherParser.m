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
#import "KM_NSDictionary+SafeValues.h"

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
    [self checkForErrorWithJSON: JSON];
    
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
    NSArray *simpleForecastDay = [[forecast km_safeDictionaryForKey:@"simpleforecast"] km_safeArrayForKey:@"forecastday"];

    NSMutableArray *tempDayArray = [NSMutableArray array];
    for (NSDictionary *day in simpleForecastDay) {
        MKWeatherCondition *condition = [[MKWeatherCondition alloc]init];
        
        condition.date = [NSDate dateWithTimeIntervalSince1970:[[[day km_safeDictionaryForKey:@"date"] km_safeStringForKey:@"epoch"]integerValue]];

        condition.summary = [day km_safeStringForKey:@"conditions"];
        condition.iconImageURL = [NSURL URLWithString:[day km_safeStringForKey:@"icon_url"]];
        condition.iconName = [day km_safeStringForKey:@"icon"];
        
        NSDictionary *highTemps = [day km_safeDictionaryForKey:@"high"];
        NSDictionary *lowTemps = [day km_safeDictionaryForKey:@"low"];
        condition.highTemp = [MKTemperature new];
        condition.lowTemp = [MKTemperature new];
        condition.highTemp.f = [highTemps[@"fahrenheit"]doubleValue];
        condition.highTemp.c = [highTemps[@"celsius"]doubleValue];
        condition.lowTemp.f = [lowTemps[@"fahrenheit"]doubleValue];
        condition.lowTemp.c = [lowTemps[@"celsius"]doubleValue];

        condition.climacon = [self climaconForIconLink:[day km_safeStringForKey:@"icon_url"] name:condition.iconName];
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
    NSDictionary *weatherDict = [JSON km_safeDictionaryForKey:@"current_observation"];
    if (!weatherDict) {
        return nil;
    }
    MKWeatherCondition *currentWeather = [MKWeatherCondition new];
    
    NSDictionary *locationInfo = [weatherDict km_safeDictionaryForKey:@"display_location"];
    
    currentWeather.temperature = [MKTemperature new];
    currentWeather.windChill = [MKTemperature new];
    currentWeather.windGust = [MKDistance new];
    currentWeather.windSpeed = [MKDistance new];
    currentWeather.windDirection = [MKWindDirection new];
    currentWeather.dewPoint = [MKTemperature new];
    currentWeather.feelsLike = [MKTemperature new];
    currentWeather.visibility = [MKDistance new];
    currentWeather.lastUpdated = [locationInfo km_safeStringForKey:@"observation_time"];
    currentWeather.date = [NSDate dateWithTimeIntervalSince1970:[[weatherDict km_safeStringForKey:@"observation_epoch"]integerValue]];
    currentWeather.summary = [weatherDict km_safeStringForKey:@"weather"];
    currentWeather.relativeHumidity = weatherDict[@"relative_humidity"];//TT
    currentWeather.temperature.f = [[weatherDict km_safeNumberForKey:@"temp_f"]doubleValue];
    currentWeather.temperature.c = [[weatherDict km_safeNumberForKey:@"temp_c"]doubleValue];
    currentWeather.dewPoint.f = [[weatherDict km_safeNumberForKey:@"dewpoint_f"]doubleValue];
    currentWeather.dewPoint.c = [[weatherDict km_safeNumberForKey:@"dewpoint_c"]doubleValue];
    currentWeather.feelsLike.f = [[weatherDict km_safeStringForKey:@"feelslike_f"]mk_safeDoubleValue];
    currentWeather.feelsLike.c = [[weatherDict km_safeStringForKey:@"feelslike_c"]mk_safeDoubleValue];
    currentWeather.visibility.mph = [[weatherDict km_safeStringForKey:@"visibility_mi"]mk_safeDoubleValue];
    currentWeather.visibility.kph = [[weatherDict km_safeStringForKey:@"visibility_km"]mk_safeDoubleValue];
    currentWeather.pressure_inches = [[weatherDict km_safeStringForKey:@"pressure_in"]mk_safeDoubleValue];
    currentWeather.windSummary = [weatherDict km_safeStringForKey:@"wind_string"];
    currentWeather.windDirection.direction = [weatherDict km_safeStringForKey:@"wind_dir"];
    currentWeather.windDirection.degrees = [[weatherDict km_safeNumberForKey:@"wind_degrees"]doubleValue];
    currentWeather.windSpeed.mph = [[weatherDict km_safeNumberForKey:@"wind_mph"]doubleValue];
    currentWeather.windSpeed.kph = [[weatherDict km_safeNumberForKey:@"wind_kph"]doubleValue];
    currentWeather.windGust.mph = [[weatherDict km_safeStringForKey: @"wind_gust_mph"] mk_safeDoubleValue];
    currentWeather.windGust.kph = [[weatherDict km_safeStringForKey: @"wind_gust_kph"]mk_safeDoubleValue];
    currentWeather.windChill.f = [[weatherDict km_safeStringForKey:@"windchill_f"]mk_safeDoubleValue];
    currentWeather.windChill.c = [[weatherDict km_safeStringForKey:@"windchill_c"]mk_safeDoubleValue];
    currentWeather.UVIndex = [[weatherDict km_safeStringForKey:@"UV"]integerValue];
    currentWeather.iconName = [weatherDict km_safeStringForKey:@"icon"];
    currentWeather.iconImageURL = [NSURL URLWithString:[weatherDict km_safeStringForKey:@"icon_url"]];
    currentWeather.climacon = [self climaconForIconLink:[weatherDict km_safeStringForKey:@"icon_url"] name:currentWeather.iconName];
    return currentWeather;
}

- (NSArray *)parseHourlyDataWithJSON: (id)JSON
{
    NSArray *hourlyForecasts = [JSON km_safeArrayForKey:@"hourly_forecast"];
    if (!hourlyForecasts) {
        return nil;
    }
    
    NSMutableArray *hourlyWeatherComponents = [NSMutableArray array];
    for (NSDictionary *hour in hourlyForecasts)
    {
        MKWeatherCondition *component = [MKWeatherCondition new];
        
        //hourlyTemp
        NSDictionary *tempStrings = [hour km_safeDictionaryForKey:@"temp"];
        component.temperature = [MKTemperature new];
        component.dewPoint = [MKTemperature new];
        component.windSpeed = [MKDistance new];
        component.humudity = [NSString new];
        
        component.temperature.f = [[tempStrings km_safeStringForKey:@"english"]mk_safeDoubleValue];
        component.temperature.c = [[tempStrings km_safeStringForKey:@"metric"]mk_safeDoubleValue];
        component.date = [NSDate dateWithTimeIntervalSince1970:[[[hour km_safeDictionaryForKey:@"FCTTIME"]km_safeStringForKey:@"epoch"]integerValue]];
        component.iconName = [NSString stringWithFormat:@"%@",[hour km_safeStringForKey:@"icon"]];
        component.summary = [hour km_safeStringForKey:@"condition"];
        component.iconImageURL = [NSURL URLWithString:[hour km_safeStringForKey:@"icon_url"]];
        component.climacon = [self climaconForIconLink:[hour km_safeStringForKey:@"icon_url"] name:component.iconName];
        NSDictionary *dewPoint = [hour km_safeDictionaryForKey:@"dewpoint"];
        NSDictionary *windSpeed = [hour km_safeDictionaryForKey:@"wspd"];
        component.dewPoint.f = [[dewPoint km_safeStringForKey:@"english"]mk_safeDoubleValue];
        component.dewPoint.c = [[dewPoint km_safeStringForKey:@"metric"]mk_safeDoubleValue];
        component.windSpeed.mph = [[windSpeed km_safeStringForKey:@"english"]mk_safeDoubleValue];
        component.windSpeed.kph = [[windSpeed km_safeStringForKey:@"metric"]mk_safeDoubleValue];

        component.humudity = hour[@"humidity"];
        [hourlyWeatherComponents addObject:component];
    }
    return hourlyWeatherComponents;
}

- (NSArray *)parse3DayWeatherForecastWithJSON: (id) JSON
{
    NSDictionary *forecast = [JSON km_safeDictionaryForKey:@"forecast"];
    if (!forecast) {
        return nil;
    }
    //simple forecast
    NSDictionary *simpleForecast = [forecast km_safeDictionaryForKey:@"simpleforecast"];
    NSArray *dayForecast = [simpleForecast km_safeArrayForKey:@"forecastday"];
    
    NSMutableArray *tempDays = [NSMutableArray array];
    for (NSDictionary *day in dayForecast) {
        
        MKWeatherCondition *component = [MKWeatherCondition new];
        component.highTemp = [MKTemperature new];
        component.lowTemp = [MKTemperature new];
        
        NSDictionary *highTemps = [day km_safeDictionaryForKey:@"high"];
        NSDictionary *lowTemps = [day km_safeDictionaryForKey:@"low"];
        component.highTemp.f = [[highTemps km_safeStringForKey:@"fahrenheit"]mk_safeDoubleValue];
        component.highTemp.c = [[highTemps km_safeStringForKey:@"celsius"]doubleValue];
        component.lowTemp.f = [[lowTemps km_safeStringForKey:@"fahrenheit"] doubleValue];
        component.lowTemp.c = [[lowTemps km_safeStringForKey:@"celsius"]doubleValue];
        component.averageHumudity = [day [@"avehumidity"]integerValue];//TT
        component.iconName = [day km_safeStringForKey:@"icon"];
        component.iconImageURL = [NSURL URLWithString:[day km_safeStringForKey:@"icon_url"]];
        component.summary = [day km_safeStringForKey:@"conditions"];
        component.date = [NSDate dateWithTimeIntervalSince1970:[[[day km_safeDictionaryForKey:@"date"]km_safeStringForKey:@"epoch"]integerValue]];
        component.climacon = [self climaconForIconLink:[day km_safeStringForKey:@"icon_url"] name:component.iconName];
        [tempDays addObject:component];
    }
    return tempDays;
}
- (NSArray *)parse3DaySummariesWithJSON: (id) summaries
{
    NSDictionary *forecast = [summaries km_safeDictionaryForKey:@"forecast"];
    if (!forecast) {
        return nil;
    }
    //"txt_forecast"
    NSDictionary *summaryForecast = [forecast km_safeDictionaryForKey:@"txt_forecast"];
    NSArray *dayNightForecast = [summaryForecast km_safeArrayForKey:@"forecastday"];
    
    NSMutableArray *tempSummary = [NSMutableArray array];
    for (NSDictionary *dayOrNight in dayNightForecast) {
        MKWeatherCondition *component = [MKWeatherCondition new];
        component.fullSummaryF = [dayOrNight km_safeStringForKey:@"fcttext"];
        component.fullSummaryC = [dayOrNight km_safeStringForKey:@"fcttext_metric"];
        component.generalTimeOfDayTitle = [dayOrNight km_safeStringForKey:@"title"];
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

#pragma mark - Error checking

- (void)checkForErrorWithJSON: (id)JSON
{
    NSDictionary *response = [JSON km_safeDictionaryForKey:@"response"];
    NSDictionary *possibleError = [response km_safeDictionaryForKey:@"error"];
    BOOL isError = [[possibleError km_safeStringForKey:@"type"] isEqualToString: @"keynotfound"];
    NSString *descriptionString = [possibleError km_safeStringForKey:@"description"];

    if (isError) {
        NSLog(@"%@", descriptionString);
        [NSException raise:@"API key not found" format:@"Please check your api key"];
    }
}

@end
