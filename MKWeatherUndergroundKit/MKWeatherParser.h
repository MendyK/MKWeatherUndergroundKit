//
//  MKWeatherParser.h
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "MKWeatherRequest.h"

@interface MKWeatherParser : NSObject

- (instancetype)initWithType: (MKWeatherRequestType)parsingType;
- (id)parseData: (NSData *)data error: (NSError **)error;

@property (nonatomic)MKWeatherRequestType parsingType;

@end
