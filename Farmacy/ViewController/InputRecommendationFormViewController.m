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
@property (weak, nonatomic) IBOutlet UISlider *nitrogenRatioSlider;
@property (weak, nonatomic) IBOutlet UISlider *phosphorousSlider;
@property (weak, nonatomic) IBOutlet UISlider *potassiumSlider;
@property (weak, nonatomic) IBOutlet UISlider *phSlider;
@property (weak, nonatomic) IBOutlet UISlider *rainfallSlider;
@property (nonatomic) double nitrogenRatio;
@property (nonatomic) double phosphorousRatio;
@property (nonatomic) double potassiumRatio;
@property (nonatomic) double phLevel;
@property (nonatomic) double rainfall;
@property (weak, nonatomic) IBOutlet UILabel *nitrogenRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phosphorousRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *potassiumRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainfallLabel;

@end

@implementation InputRecommendationFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)nitrogenValueChanged:(id)sender {
    self.nitrogenRatio = [self.nitrogenRatioSlider value];
    self.nitrogenRatioLabel.text = [NSString stringWithFormat:@"%.1f", self.nitrogenRatio];
}
- (IBAction)phosphorousValueChanged:(id)sender {
    self.phosphorousRatio = [self.phosphorousSlider value];
    self.phosphorousRatioLabel.text = [NSString stringWithFormat:@"%.1f", self.phosphorousRatio];
}
- (IBAction)potassiumValueChanged:(id)sender {
    self.potassiumRatio = [self.potassiumSlider value];
    self.potassiumRatioLabel.text = [NSString stringWithFormat:@"%.1f", self.potassiumRatio];
}
- (IBAction)phValueChanged:(id)sender {
    self.phLevel = [self.phSlider value];
    self.phLevelLabel.text = [NSString stringWithFormat:@"%.1f", self.phLevel];
}
- (IBAction)rainfallValueChanged:(id)sender {
    self.rainfall = [self.rainfallSlider value];
    self.rainfallLabel.text = [NSString stringWithFormat:@"%.1f", self.rainfall];
}

- (IBAction)didTapSaveInput:(id)sender {
    [[APIManagers shared] getForecastWeatherData:@"98007" completion:^(NSMutableArray * _Nonnull weatherData, NSError * _Nonnull error) {
        if(weatherData){
            NSLog(@"😎😎😎 Successfully loaded forecast weather API");
            WeatherCard *weatherToday = weatherData[0];
            [self.delegate didMakeCropRecommendation:self.nitrogenRatio withPhosphorousRatio:self.phosphorousRatio withPotassiumRatio:self.potassiumRatio withPh:self.phLevel withRainfallAmount:self.rainfall withTemperature:([weatherToday.avgTemperature doubleValue]-32.0)*(5.0/9.0) withHumidity:[weatherToday.avgHumidity doubleValue]];
            [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
            
        } else {
            NSLog(@"😫😫😫 Error getting forecast weather API: %@", error.localizedDescription);
        }
    }];
    

}


@end
