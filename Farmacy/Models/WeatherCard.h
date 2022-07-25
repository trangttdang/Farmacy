//
//  WeatherCard.h
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCard : NSObject

@property (nonatomic, strong) NSString *avgTemperature;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) NSString *totalPrecip;
@property (nonatomic, strong) NSString *maxWind;
@property (nonatomic, strong) NSString *avgHumidity;
@property (nonatomic, strong) NSString *conditionIconStr;
@property (nonatomic, strong) NSString *dateString;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)weatherCardsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
