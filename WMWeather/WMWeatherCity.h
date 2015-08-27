//
//  WMWeatherCity.h
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMWeatherCity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *woeid;

+ (NSString *)woeidFromString:(NSString *)string;

@end
