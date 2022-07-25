//
//  WeatherCardCell.h
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "WeatherCard.h"

NS_ASSUME_NONNULL_BEGIN
@protocol WeatherCardCellDelegate
@end

@interface WeatherCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *avgTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgHumidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrecipLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionIconImageView;
@property (weak, nonatomic) id<WeatherCardCellDelegate> delegate;
@property (strong, nonatomic) WeatherCard *weatherCard;

@end

NS_ASSUME_NONNULL_END
