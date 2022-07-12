//
//  APIManager.m
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://api.weatherapi.com";
@interface APIManager()
@end
@implementation APIManager
@synthesize data;

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if(self){
        self.data = dict;
    }
    
    return self;
}

- (instancetype)init{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    // TODO: fix code below to pull API Keys from your new Keys.plist file
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *key = [dict objectForKey: @"weather_api_key"];
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"weather_api_key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"weather_api_key"];
    }
    
    self = [self initWithDict:@{@"baseURL": baseURL,@"key":key}];
    
//    APIManager *apiManager = [[APIManager alloc] initWithDict:@{@"key":key}];
    return self;
}

//- (void)getHomeTimelineWithCompletion:(NSString *)location completion:(void(^)(NSMutableArray *weatherData, NSError *error))completion{
//    // Create a GET Request
//    NSDictionary *parameters = @{@"q": location};
//
//
//    [self GET:@"v1/current.json"
//       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSMutableArray *  _Nullable weatherDictionaries) {
//           // Success
////           NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
//        NSMutableArray *weatherData = weatherDictionaries;
//        NSLog(@"%@",@"It works");
//           completion(weatherData, nil);
//       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//           // There was a problem
//           completion(nil, error);
//    }];
//}

//- (NSURLSessionDataTask *)GET:(NSString *)URLString
//                   parameters:(id)parameters
//                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
//                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
//                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
//{
//
//    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
//                                                        URLString:URLString
//                                                       parameters:parameters
//                                                   uploadProgress:nil
//                                                 downloadProgress:downloadProgress
//                                                          success:success
//                                                          failure:failure];
//
//    [dataTask resume];
//
//    return dataTask;
//}

@end
