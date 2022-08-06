//
//  MyCrop.h
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import <Parse/Parse.h>
#import "Schedule.h"
#import "Crop.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCrop : PFObject<PFSubclassing>
@property (nonatomic) int progressPercentage;
@property (nonatomic) int irrigateIntervalDays;
@property (nonatomic) Schedule *plantedAt;
@property (nonatomic) Schedule *harvestedAt;
@property (nonatomic) Schedule *fertilizeSchedule;
@property (nonatomic) Schedule *irrigateSchedule;
@property (nonatomic) Crop *crop;

+ (void) removeFromMyCrops: (Crop * _Nullable )crop withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (MyCrop *)getMyCropUsingSchedule:(Schedule *)schedule;
@end

NS_ASSUME_NONNULL_END
