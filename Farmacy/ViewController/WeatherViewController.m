//
//  WeatherViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/11/22.
//

#import "Foundation/Foundation.h"
#import "WeatherViewController.h"
#import "APIManagers.h"
#import "WeatherCardCell.h"
#import "WeatherCard.h"
#import "JHUD.h"

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource, WeatherCardCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *forecastWeatherTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfWeatherCards;
@property (weak, nonatomic) IBOutlet UIImageView *conditionIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentHumidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPrecipLabel;
@property (strong, nonatomic) JHUD *hudView;


@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"growing-plant" ofType:@"gif"];
    self.hudView.gifImageData = [NSData dataWithContentsOfFile:path];
    self.hudView.indicatorViewSize = CGSizeMake(200, 200);
    self.hudView.messageLabel.text = @"Planting..";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
    [self.hudView hideAfterDelay:2.5];
    
    [self fetchForecastWeather];
    [self fetchCurrentWeather];
    self.forecastWeatherTableView.delegate = self;
    self.forecastWeatherTableView.dataSource = self;
    
}

- (void) fetchForecastWeather{
    //TODO: Allow farmers to input their location
    [[APIManagers shared] getForecastWeatherData:@"98007" completion:^(NSMutableArray * _Nonnull weatherData, NSError * _Nonnull error) {
        if(weatherData){
            NSLog(@"😎😎😎 Successfully loaded forecast weather API");
            self.arrayOfWeatherCards = weatherData;
        } else {
            NSLog(@"😫😫😫 Error getting forecast weather API: %@", error.localizedDescription);
        }
        [self.forecastWeatherTableView reloadData];
    }];
}

- (void) fetchCurrentWeather{
    //TODO: Allow farmers to input their location
    [[APIManagers shared] getCurrentWeatherData:@"98007" completion:^(NSDictionary * _Nonnull weatherData, NSError * _Nonnull error) {
        if(weatherData){
            NSLog(@"😎😎😎 Successfully loaded current weather API");
            float temperature = [weatherData[@"temp_f"] floatValue];
            self.currentTemperatureLabel.text = [[NSString stringWithFormat:@"%.f",temperature] stringByAppendingString: @"°F"];
            self.currentWindLabel.text = [NSString stringWithFormat:@"%.1f",[weatherData[@"wind_mph"] floatValue]];
            self.currentHumidityLabel.text = [NSString stringWithFormat:@"%.1f",[weatherData[@"humidity"] floatValue]];
            self.currentPrecipLabel.text = [NSString stringWithFormat:@"%.1f",[weatherData[@"precip_mm"] floatValue]];
            
            //Set condition icon
            NSString *URLString = weatherData[@"condition"][@"icon"];
            NSURL *url = [NSURL URLWithString: [@"https:" stringByAppendingFormat: @"%@", URLString]];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            self.conditionIconImageView.image = [UIImage imageWithData:urlData];
            
        } else {
            NSLog(@"😫😫😫 Error getting current weather API: %@", error.localizedDescription);
        }
    }];
}

//Returne rows are in each section of the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfWeatherCards.count;
}

//Returne a preconfigured cell that will be used to render the row in the table specified by the indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCardCell" forIndexPath:indexPath];
    WeatherCard *weatherCard = self.arrayOfWeatherCards[indexPath.row];
    
    cell.weatherCard = weatherCard;
    cell.avgTemperatureLabel.text = weatherCard.avgTemperature;
    cell.avgHumidityLabel.text = weatherCard.avgHumidity;
    cell.maxWindLabel.text = weatherCard.maxWind;
    cell.totalPrecipLabel.text = weatherCard.totalPrecip;
    cell.dateLabel.text = weatherCard.dateString;
    
    NSURL *url = [NSURL URLWithString: [@"https:" stringByAppendingFormat: @"%@", weatherCard.conditionIconStr]];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.conditionIconImageView.image = [UIImage imageWithData:urlData];
    cell.delegate  = self;
    
    return cell;
}



@end
