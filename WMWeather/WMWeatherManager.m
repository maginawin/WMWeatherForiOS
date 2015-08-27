//
//  WMWeatherManager.m
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMWeatherManager.h"

NSString *const kWeatherManagerNotiQueryCityStart = @"kWeatherManagerNotiQueryCityStart";
NSString *const kWeatherManagerNotiQueryCityEnd = @"kWeatherManagerNotiQueryCityEnd";
NSString *const kWeatherManagerNotiQueryCityFailure = @"kWeatherManagerNotiQueryCityFailure";

NSString *const kWeatherManagerNotiGetWeatherStart = @"kWeatherManagerNotiGetWeatherStart";
NSString *const kWeatherManagerNotiGetWeatherEnd = @"kWeatherManagerNotiGetWeatherEnd";
NSString *const kWeatherManagerNotiGetWeatherFailure = @"kWeatherManagerNotiGetWeatherFailure";

NSString *const kQueryCityPrefixString = @"http://sugg.us.search.yahoo.net/gossip-gl-location/?appid=weather&output=xml&command=";

NSString *const kQueryCityRootElementName = @"m";
NSString *const kQueryCityDetailElementName = @"s";
NSString *const kQueryCityNameElementName = @"k";
NSString *const kQueryCityWoeidElementName = @"d";

NSString *const kWeatherDetailRootElementName = @"rss";
NSString *const kWeatherDetailElementName = @"yweather:condition";
NSString *const kWeatherDetailCodeName = @"code";
NSString *const kWeatherDetailTempName = @"temp";
NSString *const kWeatherDetailDateName = @"date";

@interface WMWeatherManager () <NSXMLParserDelegate>

@property (strong, nonatomic) WMWeatherCity *city;
@property (strong, nonatomic) NSString *currentString;

@end

@implementation WMWeatherManager

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance configureBase];
    });
    return instance;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kQueryCityRootElementName]) {
        _citys = nil;
        _citys = [NSMutableArray array];
    } else if ([elementName isEqualToString:kQueryCityDetailElementName]) {
        _city = [[WMWeatherCity alloc] init];
        _city.name = [attributeDict objectForKey:kQueryCityNameElementName];
        _city.woeid = [WMWeatherCity woeidFromString:[attributeDict objectForKey:kQueryCityWoeidElementName]];
    } else if ([elementName isEqualToString:kWeatherDetailElementName]) {
        NSString *codeString = [NSString stringWithFormat:@"code%@", [attributeDict objectForKey:kWeatherDetailCodeName]];
        _weatherInfo.weather = NSLocalizedString(codeString, @"");
        _weatherInfo.temperature = [attributeDict objectForKey:kWeatherDetailTempName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string) {
        _currentString = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kQueryCityRootElementName]) {
        
        // End city query
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiQueryCityEnd object:nil];
        
    } else if ([elementName isEqualToString:kQueryCityDetailElementName]) {
        // End a city element
        [_citys addObject:_city];
        _city = nil;
    } else if ([elementName isEqualToString:kWeatherDetailRootElementName]) {
        // End weather query
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiGetWeatherEnd object:nil];
    }
}

#pragma mark - Public

- (void)getCityWithQueryName:(NSString *)queryName {
    if (!queryName) {
        NSLog(@"请输入有效名字");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kQueryCityPrefixString, [queryName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiQueryCityStart object:nil];
    
    [_operationManager GET:urlString parameters:nil success:^ (AFHTTPRequestOperation * requestOperation, id responseObject) {
        NSXMLParser *parser = responseObject;
        parser.delegate = self;
        [parser parse];
    } failure:^ (AFHTTPRequestOperation * requestOperation, NSError * error) {
        NSLog(@"获取服务器响应出错");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiQueryCityFailure object:nil];
    }];
}

- (void)getWeatherInfoWithCity:(WMWeatherCity *)city {
    
    NSString *urlString = [WMWeatherInfo weatherURLFromWoeid:city.woeid];
    NSLog(@"urlstring %@", urlString);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiGetWeatherStart object:nil];
    
    [_operationManager GET:urlString parameters:nil success:^ (AFHTTPRequestOperation * requestOperation, id responseObject) {
        NSXMLParser *parser = responseObject;
        parser.delegate = self;
        [parser parse];
    } failure:^ (AFHTTPRequestOperation * requestOperation, NSError * error) {
        NSLog(@"获取服务器响应出错");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiGetWeatherFailure object:nil];
    }];
}

#pragma mark - Private

- (void)configureBase {
    _operationManager = [AFHTTPRequestOperationManager manager];
    
    // 指定解析器
    _operationManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    _citys = [NSMutableArray array];
    _weatherInfo = [[WMWeatherInfo alloc] init];
}

@end
