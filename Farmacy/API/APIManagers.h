//
//  APIManagers.h
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManagers : AFHTTPSessionManager
@property (nonatomic, strong) NSString *APIkey;
@property (nonatomic, strong) NSURL *baseURL;
+ (instancetype)shared;
- (void)getForecastWeatherData:(NSString *)location completion:(void(^)(NSMutableArray *weatherData, NSError *error))completion;
- (void)getCurrentWeatherData:(NSString *)location completion:(void(^)(NSDictionary *weatherData, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
