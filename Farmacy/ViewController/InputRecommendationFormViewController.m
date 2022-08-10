//
//  InputRecommendationFormViewController.m
//  Farmacy
//
//  Created by Trang Dang on 8/9/22.
//

#import "InputRecommendationFormViewController.h"
#import <STPopup/STPopup.h>
#import "WeatherCard.h"
#import "APIManagers.h"

@interface InputRecommendationFormViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nitrogenRatioTextField;
@property (weak, nonatomic) IBOutlet UITextField *phosphorousRatioTextField;
@property (weak, nonatomic) IBOutlet UITextField *potassiumTextField;
@property (weak, nonatomic) IBOutlet UITextField *phLevelTextField;
@property (weak, nonatomic) IBOutlet UITextField *rainfallTextField;
@end

@implementation InputRecommendationFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapSaveInput:(id)sender {
    [[APIManagers shared] getForecastWeatherData:@"98007" completion:^(NSMutableArray * _Nonnull weatherData, NSError * _Nonnull error) {
        if(weatherData){
            NSLog(@"😎😎😎 Successfully loaded forecast weather API");
            WeatherCard *weatherToday = weatherData[0];
            [self.delegate didMakeCropRecommendation:[self.nitrogenRatioTextField.text doubleValue] withPhosphorousRatio:[self.phosphorousRatioTextField.text doubleValue] withPotassiumRatio:[self.potassiumTextField.text doubleValue] withPh:[self.phLevelTextField.text doubleValue] withRainfallAmount:[self.rainfallTextField.text doubleValue] withTemperature:[weatherToday.avgTemperature doubleValue] withHumidity:[weatherToday.avgHumidity doubleValue]];
            [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
            
        } else {
            NSLog(@"😫😫😫 Error getting forecast weather API: %@", error.localizedDescription);
        }
    }];
    

}


@end
