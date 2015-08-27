//
//  ViewController.m
//  WMWeather
//
//  Created by maginawin on 15/8/27.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "ViewController.h"
#import "WMWeatherManager.h"

NSString *const kViewControlerCellId = @"kViewControlerCellId";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *citys;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _citys = [NSMutableArray array];
    _mTableView.tableFooterView = [[UIView alloc] init];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kWeatherManagerNotiQueryCityEnd) name:kWeatherManagerNotiQueryCityEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kWeatherManagerNotiGetWeatherEnd) name:kWeatherManagerNotiGetWeatherEnd object:nil];
}

- (void)kWeatherManagerNotiQueryCityEnd {
    dispatch_async(dispatch_get_main_queue(), ^ {
        _citys = [WMWeatherManager sharedInstance].citys;
        
        [_mTableView reloadData];
        
        for (WMWeatherCity *city in _citys) {
            NSLog(@"city name : %@, city woeid: %@ \n", city.name, city.woeid);
        }
    });
}

- (void)kWeatherManagerNotiGetWeatherEnd {
    dispatch_async(dispatch_get_main_queue(), ^ {
        _weather.text = [WMWeatherManager sharedInstance].weatherInfo.weather;
        _temperature.text = [WMWeatherManager sharedInstance].weatherInfo.temperature;
    });
}

- (IBAction)accessSecret:(id)sender {
    [self.view endEditing:YES];
    
    [[WMWeatherManager sharedInstance] getCityWithQueryName:_address.text];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WMWeatherCity *city = _citys[indexPath.row];
    
    [[WMWeatherManager sharedInstance] getWeatherInfoWithCity:city];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kViewControlerCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kViewControlerCellId];
    }
    
    WMWeatherCity *city = _citys[indexPath.row];
    
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.woeid;
    
    return cell;
}

@end
