//
//  Crop.h
//  Farmacy
//
//  Created by Trang Dang on 7/12/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Crop : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
// By use, crops fall into six categories: food crops, feed crops, fiber crops, oil crops, ornamental crops, and industrial crops
@property (nonatomic, strong) NSString *typeByUse;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *baseTemperature;
@property (nonatomic, strong) NSArray *DailyGrowingDegreeDays;

+ (void) addToMyCrops: (Crop * _Nullable )crop withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) fetchCropDailyGrowingDegreeDays;
@end

NS_ASSUME_NONNULL_END
