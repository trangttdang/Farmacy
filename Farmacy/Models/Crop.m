//
//  Crop.m
//  Farmacy
//
//  Created by Trang Dang on 7/12/22.
//

#import "Crop.h"
#import "MyCrop.h"
#import "GDDAPIManager.h"
#import "IrrigateSchedule.h"

@implementation Crop
@dynamic name;
// By use, crops fall into six categories: food crops, feed crops, fiber crops, oil crops, ornamental crops, and industrial crops
@dynamic typeByUse;
@dynamic image;
@dynamic baseTemperature;
@dynamic DailyGrowingDegreeDays;
@dynamic cropCoefficient;
@dynamic rootingDepth;
@dynamic readilyAvailableSoilWater;

+ (nonnull NSString *)parseClassName {
    return @"Crop";
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (void) addToMyCrops: (Crop * _Nullable )crop withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"MyCrop"];
    // Retrieve the object by id
    [query whereKey:@"crop" equalTo:crop];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        //"No results matched the query" error
        if(error.code == 101){
            NSLog(@"Crop is not added yet");
            __block MyCrop *myCrop = [MyCrop new];
            myCrop.crop = crop;
            myCrop.progressPercentage = 0;
            [self irrigateIntervalDays:myCrop.crop completion:^(int intervalDays) {
                myCrop.irrigateIntervalDays = intervalDays;
                [self fetchCropDailyGrowingDegreeDays: myCrop.crop completion:^(NSArray *dates) {
                    Schedule *fSchedule = [Schedule new];
                    Schedule *iSchedule = [Schedule new];
                    Schedule *plantSchedule = [Schedule new];
                    Schedule *harvestSchedule = [Schedule new];
                    NSDateComponents *irrigateDayComp = [[NSDateComponents alloc] init];
                    irrigateDayComp.day = myCrop.irrigateIntervalDays;
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    //Implemented Recommendation System based on time series data using Latent Dirichlet Allocation (LDA) in Python
                    //Identified fertilize suggested time
                    fSchedule.time = [NSDate date];
                    iSchedule.time = [calendar dateByAddingComponents:irrigateDayComp toDate:[NSDate date] options:0];
                    plantSchedule.time = dates[0];
                    harvestSchedule.time = dates[1];
                    myCrop.fertilizeSchedule = fSchedule;
                    myCrop.irrigateSchedule = iSchedule;
                    myCrop.plantedAt = plantSchedule;
                    myCrop.harvestedAt = harvestSchedule;
                    [myCrop saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable newError) {
                        completion(succeeded, newError);
                    }];
                }];
            }];
            
        } else if (error == nil){
            NSLog(@"Crop is already added");
            completion(false, nil);
        } else{
            NSLog(@"Unknown error %@", error.localizedDescription);
            completion(false, error);
        }
    }];
    
}

+ (void) fetchCropDailyGrowingDegreeDays: (Crop * _Nullable )crop completion:(void (^)(NSArray *dates ))completion{
    //TODO: Allow farmers to choose location, then covert to station ID
    [[GDDAPIManager shared] getDailyGrowingDegreeDays:@"stn01" withBaseTemperature:crop.baseTemperature completion:^(NSArray * _Nonnull dailyGDDs, NSError * _Nonnull error) {
        if(dailyGDDs){
            NSLog(@"😎😎😎 Successfully loaded Daily Growing Degree Day");
            crop.DailyGrowingDegreeDays = dailyGDDs;
            
            //Find suggested plant date (strating from today) and harvest date
            //To do this, find the X days interval (harvestdate-plantdate) that has the highest highest sum of GDDs
            float currentAccumulatedGDDs = [crop.DailyGrowingDegreeDays[0] floatValue];
            float maxAccumulatedGDDs = [crop.DailyGrowingDegreeDays[0] floatValue];
            int fromIdx = 0;
            int toIdx = (int) crop.DailyGrowingDegreeDays.count;
            int prevFromIdx = fromIdx;
            int prevToIdx = toIdx;
            for (int i = 1; i < (int) crop.DailyGrowingDegreeDays.count;i++){
                float gdd = [crop.DailyGrowingDegreeDays[i] floatValue];
                currentAccumulatedGDDs = MAX(gdd, gdd + currentAccumulatedGDDs);
                if (currentAccumulatedGDDs == gdd) fromIdx = i;
                toIdx = i;
                maxAccumulatedGDDs = MAX(maxAccumulatedGDDs, currentAccumulatedGDDs);
                if(maxAccumulatedGDDs > currentAccumulatedGDDs){
                    fromIdx = prevFromIdx;
                    toIdx = prevToIdx;
                }
                prevFromIdx = fromIdx;
                prevToIdx = toIdx;
            }
            NSLog(@"Suggested plant date: %d", fromIdx);
            NSLog(@"Suggested harvest date: %d", toIdx);
            NSLog(@"X days interval: %d", toIdx-fromIdx);
            
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            gregorian.timeZone =  [NSTimeZone systemTimeZone];
            NSDateComponents *plantDateCom = [[NSDateComponents alloc] init];
            plantDateCom.day = fromIdx;
            NSDateComponents *harvestDateCom = [[NSDateComponents alloc] init];
            harvestDateCom.day = toIdx;
            NSDate *plantDate = [gregorian dateFromComponents:plantDateCom];
            NSDate *expectedHarvestDate = [gregorian dateFromComponents:harvestDateCom];
            NSMutableArray *dates = [[NSMutableArray alloc]init];
            [dates addObject:plantDate];
            [dates addObject:expectedHarvestDate];
            completion(dates);
        } else{
            NSLog(@"😫😫😫 Error getting Daily Growing Degree Day: %@", error.localizedDescription);
            
        }
    }];
}
+ (void)irrigateIntervalDays:(Crop *)crop completion:(void (^)(int intervalDays ))completion{
    IrrigateSchedule *irrigateSchedule = [[IrrigateSchedule alloc] init];
    //TODO: Fetch values from API later
    float solarRadiation = [irrigateSchedule wm2MJ:254.0];
    float netIncomingShortwaveRadiation = [irrigateSchedule netIncomingShortwaveRadiation:solarRadiation];
    float tempMinC = 16.27;
    float tempMaxC = 23.08;
    float tempMinK = [irrigateSchedule celsius2Kelvin:tempMinC];
    float tempMaxK = [irrigateSchedule celsius2Kelvin:tempMaxC];
    //from location of farmers, temporarily hard code
    float altitute = 2347.57;
    float latitude = [irrigateSchedule degree2Radians:37.71];
    float dayOfYear = 10.0;
    float airTempC = -5.722222;
    float airTempK = [irrigateSchedule celsius2Kelvin:airTempC];
    float windSpeed = 9;
    float solarDeclination = [irrigateSchedule solarDeclination:dayOfYear];
    float sunsetHourAngle = [irrigateSchedule sunsetHourAngle:latitude withSolarDeclination:solarDeclination];
    float inverseRelativeDistanceEarthSun = [irrigateSchedule inverseRelativeDistanceEarthSun:dayOfYear];
    float extraterrestrialRadiation = [irrigateSchedule extraterrestrialRadiation:latitude withSolarDeclination:solarDeclination withSunsetHourAngle:sunsetHourAngle withInverseRelativeDistanceEarthSun:inverseRelativeDistanceEarthSun];
    float clearSkyRadiation = [irrigateSchedule clearSkyRadiation:altitute withExtraterrestrialRadiation:extraterrestrialRadiation];
    float actualVapourPressure = [irrigateSchedule actualVapourPressure:tempMinC];
    float netOutgoingLongwaveRadiation = [irrigateSchedule netOutgoingLongwaveRadiation:tempMinK withTempMaxKel:tempMaxK withSolarRadiation:solarRadiation withClearSkyRadiation:clearSkyRadiation withActualVapourPressure:actualVapourPressure];
    float netRadiation = [irrigateSchedule netRadiation:netIncomingShortwaveRadiation withNetOutgoingLongWaveRadiation:netOutgoingLongwaveRadiation];
    float saturationVapourPressure = [irrigateSchedule saturationVapourPressure:tempMinC withTempMaxCel:tempMaxC];
    float atmPressure = [irrigateSchedule atmPressure:altitute];
    float psychrometricConstant = [irrigateSchedule psychrometricConstant:atmPressure];
    float deltaSaturationVapourPressure = [irrigateSchedule deltaSaturationVapourPressure:airTempC];
    float ETo = [irrigateSchedule evapotranspiration:netRadiation withAirTempKel:airTempK withWindSpeed:windSpeed withSaturationVapourPressure:saturationVapourPressure withActualVapourPressure:actualVapourPressure withDeltaSvp:deltaSaturationVapourPressure withPsychrometricConstant:psychrometricConstant];
    float rootingDepth = crop.rootingDepth;
    float ETcrop = ETo *crop.cropCoefficient;
    if (ETo < 3.0){
        rootingDepth = rootingDepth*(130/100);
    } else if (ETo > 8.0){
        rootingDepth = rootingDepth/(130/100);
    }
    float irrigateIntervalDays = rootingDepth*crop.readilyAvailableSoilWater/ETcrop;
    
    NSLog(@"evapotranspiration is %f", ETo);
    NSLog(@"irrigation interval is: %F", irrigateIntervalDays);
    completion((int) irrigateIntervalDays);
}


@end
