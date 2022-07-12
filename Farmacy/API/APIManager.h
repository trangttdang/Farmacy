//
//  APIManager.h
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
@property (nonatomic, strong) NSDictionary *data;

+ (instancetype)shared;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
