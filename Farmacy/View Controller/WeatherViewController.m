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

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource, WeatherCardCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *forecastWeatherTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfWeatherCards;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //SOLUTION 2: get current weather API
    //    [self fetchWeatherAPI];
    
    //SOLUTION 1: get current weather API
//    [self fetchCurrentWeather];
    [self fetchForecastWeather];
    
    self.forecastWeatherTableView.delegate = self;
    self.forecastWeatherTableView.dataSource = self;
    
}

//SOLUTION 2: get current weather API
- (void)fetchWeatherAPI{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"weather_api_key"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weatherapi.com/v1/current.json?key=<MY_KEY>&q=London"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);

        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dataDictionary);
        }
    }];

    [task resume];
    
}

//SOLUTION 1: get current weather API
//- (void) fetchCurrentWeather{
//    [[APIManagers shared] getCurrentWeatherData:@"London" completion:^(NSMutableArray * _Nonnull weatherData, NSError * _Nonnull error) {
//        if(weatherData){
//            NSLog(@"😎😎😎 Successfully loaded weather API");
//        } else {
//            NSLog(@"😫😫😫 Error getting weather API: %@", error.localizedDescription);
//        }
//    }];
//}

- (void) fetchForecastWeather{
    [[APIManagers shared] getForecastWeatherData:@"London" completion:^(NSMutableArray * _Nonnull weatherData, NSError * _Nonnull error) {
        if(weatherData){
            NSLog(@"😎😎😎 Successfully loaded weather API");
            self.arrayOfWeatherCards = weatherData;
        } else {
            NSLog(@"😫😫😫 Error getting weather API: %@", error.localizedDescription);
        }
        [self.forecastWeatherTableView reloadData];
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
    
    cell.avgTemperatureLabel.text = [NSString stringWithFormat:@"%@", weatherCard.avgTemperature];
    
    cell.avgHuminityLabel.text = [NSString stringWithFormat:@"%@", weatherCard.avgHumidity];
    
    cell.maxWindLabel.text = [NSString stringWithFormat:@"%@", weatherCard.maxWind];
    
    cell.totalPrecipLabel.text = [NSString stringWithFormat:@"%@", weatherCard.totalPrecip];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", weatherCard.dateString];
    
    cell.delegate  = self;
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
