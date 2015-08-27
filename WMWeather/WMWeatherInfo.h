//
//  WMWeatherInfo.h
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WeatherInfoTempType) {
    WeatherInfoTempTypeC = 0x01,
    WeatherInfoTempTypeF = 0x01 << 1
};

@interface WMWeatherInfo : NSObject

@property (strong, nonatomic) NSString *weather;
@property (strong, nonatomic) NSString *temperature;

+ (NSString *)weatherURLFromWoeid:(NSString *)woeid;

+ (void)setupWeatherInfoTempType:(WeatherInfoTempType)tempType;
+ (WeatherInfoTempType)weatherInfoTempTypeUserSet;
+ (NSString *)weatherInfoTempTypeUserSetString;

@end
