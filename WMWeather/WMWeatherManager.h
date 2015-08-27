//
//  WMWeatherManager.h
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "WMWeatherInfo.h"
#import "WMWeatherCity.h"

extern NSString *const kWeatherManagerNotiQueryCityStart;
extern NSString *const kWeatherManagerNotiQueryCityEnd;
extern NSString *const kWeatherManagerNotiQueryCityFailure;

extern NSString *const kWeatherManagerNotiGetWeatherStart;
extern NSString *const kWeatherManagerNotiGetWeatherEnd;
extern NSString *const kWeatherManagerNotiGetWeatherFailure;

@interface WMWeatherManager : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

@property (strong, nonatomic) NSMutableArray *citys;

@property (strong, nonatomic) WMWeatherInfo *weatherInfo;

- (void)getCityWithQueryName:(NSString *)queryName;

- (void)getWeatherInfoWithCity:(WMWeatherCity *)city;

@end
