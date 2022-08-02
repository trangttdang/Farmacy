//
//  GDDAPIManager.m
//  Farmacy
//
//  Created by Trang Dang on 7/28/22.
//

#import "GDDAPIManager.h"

static NSString * const baseURLString = @"https://coagmet.colostate.edu/data";
@interface GDDAPIManager()

@end

@implementation GDDAPIManager
@dynamic baseURL;
+ (instancetype)shared {
    static GDDAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self.baseURL = [NSURL URLWithString:baseURLString];
    return self;
}

- (void)getDailyGrowingDegreeDays:(NSString *)stationID withBaseTemperature:(NSString *)baseTemperature completion:(void(^)(NSArray *dailyGDDs, NSError *error))completion{
    NSString *endPoint = [@"gdd/" stringByAppendingString:[stationID stringByAppendingString:@".json"]];
    //TODO: Find average values of previous 5 years to have more accurate results
    NSString *fromDate = @"2021-01-01";
    NSString *toDate = @"2021-12-31";
    
    NSDictionary *parameters = @{@"from":fromDate, @"to":toDate, @"base":baseTemperature};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:endPoint parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable dailyGDDsDictionary) {
        NSLog(@"%@",@"Successfully get Daily Growing Degree Days");
        completion(dailyGDDsDictionary[@"daily"],nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}
@end
