//
//  MyCrop.m
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import "MyCrop.h"
#import "IrrigateSchedule.h"
@implementation MyCrop

@dynamic plantedAt;
@dynamic harvestedAt;
@dynamic progressPercentage;
@dynamic irrigateSchedule;
@dynamic fertilizeSchedule;
@dynamic crop;

+ (nonnull NSString *)parseClassName {
    return @"MyCrop";
}
+ (void) removeFromMyCrops: (MyCrop * _Nullable )myCrop withCompletion: (PFBooleanResultBlock  _Nullable)completion {
        PFQuery *query = [PFQuery queryWithClassName:@"MyCrop"];
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:myCrop.objectId
                                     block:^(PFObject *crop, NSError *error) {
            [myCrop deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable newError) {
                [myCrop[@"fertilizeSchedule"] deleteInBackground];
                [myCrop[@"irrigateSchedule"] deleteInBackground];
                completion(succeeded, newError);
            }];
        }];
}

+ (MyCrop *)getMyCropUsingSchedule:(Schedule *)schedule{
    PFQuery *iQuery = [PFQuery queryWithClassName:@"MyCrop"];
    PFQuery *fQuery = [PFQuery queryWithClassName:@"MyCrop"];
    [iQuery whereKey:@"irrigateSchedule" equalTo:schedule];
    [fQuery whereKey:@"fertilizeSchedule" equalTo:schedule];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[iQuery ,fQuery]];
    [query includeKey:@"crop"];
    
    return [query getFirstObject];
}

+ (void)irrigateIntervalDays{
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
    NSLog(@"evapotranspiration is %f", ETo);
}


@end
