//
//  APIManagers.m
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import "APIManagers.h"
#import "WeatherCard.h"

static NSString * const baseURLString = @"https://api.weatherapi.com";
@interface APIManagers()

@end

@implementation APIManagers
+ (instancetype)shared {
    static APIManagers *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (instancetype)init {
    self.baseURL = [NSURL URLWithString:baseURLString];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    self.APIkey = [dict objectForKey: @"weather_api_key"];
    
    return self;
}

//- (void)getCurrentWeatherData:(NSString *)location completion:(void(^)(NSMutableArray *weatherData, NSError *error))completion{
//
//    NSDictionary *parameters = @{@"key": self.APIkey,@"q": location};
//
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    [manager GET:@"v1/current.json" parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSMutableArray *  _Nullable weatherDictionaries) {
//                   // Success
//                NSMutableArray *weatherData = weatherDictionaries;
//                NSLog(@"%@",@"Successfully get current weather");
//                   completion(weatherData, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completion(nil, error);
//    }];
//}

- (void)getForecastWeatherData:(NSString *)location completion:(void(^)(NSMutableArray *weatherData, NSError *error))completion{

    NSDictionary *parameters = @{@"key": self.APIkey,@"q": location,@"days":@10};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:@"v1/forecast.json" parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable weatherDictionaries) {
                   // Success
        
        NSMutableArray *weatherData = [WeatherCard weatherCardsWithArray:weatherDictionaries[@"forecast"][@"forecastday"]];
                NSLog(@"%@",@"Successfully get forecast weather");
                   completion(weatherData, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
@end
