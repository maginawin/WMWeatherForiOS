//
//  WMWeatherInfo.m
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMWeatherInfo.h"

NSString *const kWeatherURLPrefixString = @"http://weather.yahooapis.com/forecastrss?w=%@&u=%@";
NSString *const kWeatherInfoTempTypeUserSet = @"kWeatherInfoTempTypeUserSet";

@implementation WMWeatherInfo

- (id)init {
    self = [super init];
    if (self) {
        self.weather = @"----";
        self.temperature = @"";
    }
    return self;
}

+ (NSString *)weatherURLFromWoeid:(NSString *)woeid {
    NSString *value0 = @"https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20weather.woeid%20WHERE%20w%3D%22";
    NSString *value1 = @"%22%20and%20u%3D%22";
    NSString *value2 = @"%22&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
//    NSString *value3 = @"";
    
    NSString *tempString = @"c";
    
    switch ([self weatherInfoTempTypeUserSet]) {
        case WeatherInfoTempTypeC: {
            tempString = @"c";
            break;
        }
        case WeatherInfoTempTypeF: {
            tempString = @"f";
        }
    }
    
    NSString *woeidString = [NSString stringWithFormat:@"%@%@%@%@%@", value0, woeid, value1, tempString, value2];
    return woeidString;
}

+ (void)setupWeatherInfoTempType:(WeatherInfoTempType)tempType {
    [[NSUserDefaults standardUserDefaults] setInteger:tempType forKey:kWeatherInfoTempTypeUserSet];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (WeatherInfoTempType)weatherInfoTempTypeUserSet {
    NSInteger value = [[NSUserDefaults standardUserDefaults] integerForKey:kWeatherInfoTempTypeUserSet];
    if (!value) {
        value = WeatherInfoTempTypeC;
    }
    return value;
}
+ (NSString *)weatherInfoTempTypeUserSetString {
    NSString *value = @"℃";
    switch ([self weatherInfoTempTypeUserSet]) {
        case WeatherInfoTempTypeC: {
            value = @"℃";
            break;
        }
        case WeatherInfoTempTypeF: {
            value = @"℉";
        }
    }
    return value;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)input,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    
    
    return outputStr;
}
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
