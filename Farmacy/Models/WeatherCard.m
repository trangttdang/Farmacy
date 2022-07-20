//
//  WeatherCard.m
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import "WeatherCard.h"

@implementation WeatherCard
+ (NSMutableArray *)weatherCardsWithArray:(NSArray *)dictionaries{
    NSMutableArray *weatherCards = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        NSLog(@"%@",dictionary);
        WeatherCard *weatherCard = [[WeatherCard alloc] initWithDictionary:dictionary];
        [weatherCards addObject:weatherCard];
    }
    return weatherCards;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        self.avgTemperature = dictionary[@"day"][@"avgtemp_f"];
        self.avgHumidity = dictionary[@"day"][@"avghumidity"];
        self.totalPrecip = dictionary[@"day"][@"totalprecip_mm"];
        self.maxWind = dictionary[@"day"][@"maxwind_mph"];
        
        //convert string to date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dictionary[@"date"]];
        //get weekday from date
        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
        [weekday setDateFormat: @"EE"];
        
        self.dateString = [weekday stringFromDate:date];
        self.conditionIconStr = dictionary[@"day"][@"condition"][@"icon"];
        
    }
    return self;
}
@end
