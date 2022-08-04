//
//  IrrigateSchedule.m
//  Farmacy
//
//  Created by Trang Dang on 8/4/22.
//

#import "IrrigateSchedule.h"
@implementation IrrigateSchedule

- (float)evapotranspiration: (float) netRadiation withAirTempKel:(float)t withWindSpeed:(float)windSpeed withSaturationVapourPressure:(float)saturationVapourPressure withActualVapourPressure:(float)actualVapourPressure withDeltaSvp:(float)deltaSvp withPsychrometricConstant: (float)psychrometricConstant{
    float a1 = (0.408 * netRadiation * deltaSvp / (deltaSvp + (psychrometricConstant * (1 + 0.34 * windSpeed))));
    float a2 = (900 * windSpeed / t * (saturationVapourPressure - actualVapourPressure) * psychrometricConstant /
                (deltaSvp + (psychrometricConstant * (1 + 0.34 * windSpeed))));
    return a1+a2;
}

- (float)netRadiation: (float)netIncomingShortwaveRadiation withNetOutgoingLongWaveRadiation:(float)netOutgoingLongwaveRadiation{
    return netIncomingShortwaveRadiation-netOutgoingLongwaveRadiation;
}

- (float)netIncomingShortwaveRadiation: (float)solarRadiation{
    float albedo = 0.23;
    return (1-albedo)*solarRadiation;
}

- (float)netOutgoingLongwaveRadiation: (float)tempMinKel withTempMaxKel:(float)tempMaxKel withSolarRadiation: (float)solarRadiation withClearSkyRadiation: (float)clearSkyRadiation withActualVapourPressure:(float)actualVapourPressure{
    const float STEFAN_BOLTZMANN_CONSTANT = 0.000000004903;
    float tmp1 = (STEFAN_BOLTZMANN_CONSTANT *
                  ((pow(tempMaxKel, 4) + pow(tempMinKel, 4)) / 2));
    float tmp2 = (0.34 - (0.14 * sqrt(actualVapourPressure)));
    float tmp3 = 1.35 * (solarRadiation / clearSkyRadiation) - 0.35;
    return tmp1 * tmp2 * tmp3;
}

-(float)clearSkyRadiation: (float)altitude withExtraterrestrialRadiation:(float)extraterrestrialRadiation{
    return (0.00002 *altitude +0.75)*extraterrestrialRadiation;
}

-(float)extraterrestrialRadiation: (float)latitude withSolarDeclination: (float)solarDeclination withSunsetHourAngle:(float)sunsetHourAngle withInverseRelativeDistanceEarthSun:(float)inverseRelativeDistanceEarthSun{
    const float SOLAR_CONSTANT = 0.0820;
    float tmp1 = (24.0 * 60.0) / PI;
    float tmp2 = sunsetHourAngle * sin(latitude) * sin(solarDeclination);
    float tmp3 = cos(latitude) * cos(solarDeclination) * sin(sunsetHourAngle);
    return tmp1 * SOLAR_CONSTANT * inverseRelativeDistanceEarthSun * (tmp2 + tmp3);
}

-(float)solarDeclination: (float)dayOfYear{
    return  0.409 * sin(((2.0 * PI / 365.0) * dayOfYear - 1.39));
}

-(float)sunsetHourAngle: (float)latitude withSolarDeclination:(float)solarDeclination{
    float cosineSunsetHourAngle = -tan(latitude)*tan(solarDeclination);
    return acos(fmin(fmax(cosineSunsetHourAngle, -1.0), 1.0));
}

-(float)inverseRelativeDistanceEarthSun: (float)dayOfYear{
    return 1 + (0.033 * cos((2.0 * PI / 365.0) * dayOfYear));
}

-(float)actualVapourPressure:(float)tempMinCel{
    return 0.611 * expf((17.27 * tempMinCel) / (tempMinCel + 237.3));
}

-(float)saturationVapourPressure:(float)tempMinCel withTempMaxCel:(float)tempMaxCel{
    float t = (tempMinCel+tempMaxCel)/2;
    return 0.6108 * expf((17.27 * t) / (t + 237.3));
}

-(float)deltaSaturationVapourPressure: (float)airTempCel{
    float tmp = 4098 * (0.6108 * expf((17.27 * airTempCel) / (airTempCel + 237.3)));
    return tmp / pow((airTempCel + 237.3), 2);
}

-(float)psychrometricConstant: (float)atmPressure{
    return 0.000665 * atmPressure;
}

-(float)atmPressure:(float)altitude{
    float tmp = (293.0 - (0.0065 * altitude)) / 293.0;
    return pow(tmp, 5.26) * 101.3;
}

//CONVERT FUNCTIONS
-(float)celsius2Kelvin: (float)celsius{
    return celsius+273.15;
}
-(float)kelvin2Celsius: (float)kelvin{
    return kelvin-273.15;
}
-(float)degree2Radians: (float)degrees{
    return degrees * (PI / 180.0);
}
-(float)wm2MJ: (float)solarRadiationInWm{
    //Convert from [W m-2 day-1] to [MJ m-2 day-1]
    return solarRadiationInWm / (1000000/86000);
}
@end
