//
//  IrrigateSchedule.h
//  Farmacy
//
//  Created by Trang Dang on 8/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static float const PI = 3.14159265;
@interface IrrigateSchedule : NSObject
- (float)evapotranspiration: (float) netRadiation withAirTempKel:(float)t withWindSpeed:(float)windSpeed withSaturationVapourPressure:(float)saturationVapourPressure withActualVapourPressure:(float)actualVapourPressure withDeltaSvp:(float)deltaSvp withPsychrometricConstant: (float)psychrometricConstant;
- (float)netRadiation: (float)netIncomingShortwaveRadiation withNetOutgoingLongWaveRadiation:(float)netOutgoingLongwaveRadiation;
- (float)netIncomingShortwaveRadiation: (float)solarRadiation;
- (float)netOutgoingLongwaveRadiation: (float)tempMinKel withTempMaxKel:(float)tempMaxKel withSolarRadiation: (float)solarRadiation withClearSkyRadiation: (float)clearSkyRadiation withActualVapourPressure:(float)actualVapourPressure;
-(float)clearSkyRadiation: (float)altitude withExtraterrestrialRadiation:(float)extraterrestrialRadiation;
-(float)extraterrestrialRadiation: (float)latitude withSolarDeclination: (float)solarDeclination withSunsetHourAngle:(float)sunsetHourAngle withInverseRelativeDistanceEarthSun:(float)inverseRelativeDistanceEarthSun;
-(float)solarDeclination: (float)dayOfYear;
-(float)sunsetHourAngle: (float)latitude withSolarDeclination:(float)solarDeclination;
-(float)inverseRelativeDistanceEarthSun: (float)dayOfYear;
-(float)actualVapourPressure:(float)tempMinCel;
-(float)saturationVapourPressure:(float)tempMinCel withTempMaxCel:(float)tempMaxCel;
-(float)deltaSaturationVapourPressure: (float)airTempCel;
-(float)psychrometricConstant: (float)atmPressure;
-(float)atmPressure:(float)altitude;
-(float)celsius2Kelvin: (float)celsius;
-(float)kelvin2Celsius: (float)kelvin;
-(float)degree2Radians: (float)degrees;
-(float)wm2MJ: (float)solarRadiationInWm;
@end

NS_ASSUME_NONNULL_END
