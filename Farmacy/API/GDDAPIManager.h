//
//  GDDAPIManager.h
//  Farmacy
//
//  Created by Trang Dang on 7/28/22.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDDAPIManager : AFHTTPSessionManager
@property (nonatomic, strong) NSURL *baseURL;
+ (instancetype)shared;
- (void)getDailyGrowingDegreeDays:(NSString *)stationID withBaseTemperature:(NSString *)baseTemperature completion:(void(^)(NSArray *dailyGDDs, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
