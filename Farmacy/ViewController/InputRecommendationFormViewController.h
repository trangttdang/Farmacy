//
//  InputRecommendationFormViewController.h
//  Farmacy
//
//  Created by Trang Dang on 8/9/22.
//

#import <UIKit/UIKit.h>
#import "WeatherCard.h"
NS_ASSUME_NONNULL_BEGIN
@protocol InputRecomMendationFormDelegate

- (void)didMakeCropRecommendation:(double)nitrogenRatio withPhosphorousRatio:(double)phosphorousRatio withPotassiumRatio:(double)potassiumRatio withPh:(double)ph withRainfallAmount:(double)rainFallAmount withTemperature:(double)avgTemp withHumidity:(double)avgHumidity;

@end
@interface InputRecommendationFormViewController : UIViewController
@property (nonatomic, weak) id<InputRecomMendationFormDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
