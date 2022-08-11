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
#import <CoreLocation/CoreLocation.h>
#import "FBSDKCoreKit/FBSDKProfile.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource, WeatherCardCellDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *forecastWeatherTableView;
@property (strong, nonatomic) NSMutableArray *arrayOfWeatherCards;
@property (weak, nonatomic) IBOutlet UIImageView *conditionIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentHumidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPrecipLabel;
@property (strong, nonatomic) JHUD *hudView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;

@property (weak, nonatomic) IBOutlet UIButton *logoutWithParseButton;

@end

@implementation WeatherViewController
@synthesize fbLogoutButtonView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkProfile];
    [self loadingAnimation];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void) checkProfile{
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if(profile){
                FBSDKLoginButton *logoutButton = [[FBSDKLoginButton alloc]init];
                logoutButton.delegate = self;
                logoutButton.center = self.fbLogoutButtonView.center;
                [self.view addSubview:logoutButton];
                self.logoutWithParseButton.hidden = YES;
            }
        }];
    });
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton * _Nonnull)logoutButton{
    NSLog(@"User log out");
    SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mySceneDelegate.window.rootViewController = loginViewController;
    
}

- (IBAction)logoutUserWithParse:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User loged out successfully");
            SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            mySceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

-(void) loadingAnimation{
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"growing-plant" ofType:@"gif"];
    self.hudView.gifImageData = [NSData dataWithContentsOfFile:path];
    self.hudView.indicatorViewSize = CGSizeMake(200, 200);
    self.hudView.messageLabel.text = @"Planting..";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
    [self.hudView hideAfterDelay:2.5];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"Location %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    self.longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    [self fetchForecastWeather];
    [self fetchCurrentWeather];
    self.forecastWeatherTableView.delegate = self;
    self.forecastWeatherTableView.dataSource = self;
}


- (void) fetchForecastWeather{
    NSString *location = [self.latitude stringByAppendingString:[@"," stringByAppendingString: self.longitude]];
    [[APIManagers shared] getForecastWeatherData:location completion:^(NSMutableArray * _Nonnull weatherData, NSError * _Nonnull error) {
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
    NSString *location = [self.latitude stringByAppendingString:[@"," stringByAppendingString: self.longitude]];
    [[APIManagers shared] getCurrentWeatherData:location completion:^(NSDictionary * _Nonnull weatherData, NSError * _Nonnull error) {
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
