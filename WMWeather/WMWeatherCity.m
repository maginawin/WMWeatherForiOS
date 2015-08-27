//
//  WMWeatherCity.m
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMWeatherCity.h"

@implementation WMWeatherCity

+ (NSString *)woeidFromString:(NSString *)string {
    if (!string) {
        return @"";
    }
    
    NSArray *firstSeps = [string componentsSeparatedByString:@"="];
    
    if (firstSeps.count < 3) {
        return @"";
    }
    
    NSString *actualSep = firstSeps[2];
    
    NSArray *secondSeps = [actualSep componentsSeparatedByString:@"&"];
    
    if (secondSeps.count < 1) {
        return @"";
    }
    
    return secondSeps.firstObject;
}

@end
