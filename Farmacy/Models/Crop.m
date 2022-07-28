//
//  Crop.m
//  Farmacy
//
//  Created by Trang Dang on 7/12/22.
//

#import "Crop.h"
#import "MyCrop.h"
#import "GDDAPIManager.h"
@implementation Crop

@dynamic name;
@dynamic typeByUse;
@dynamic image;
@dynamic baseTemperature;

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
            MyCrop *myCrop = [MyCrop new];
            myCrop.crop = crop;
            myCrop.progressPercentage = [@0 intValue];
            [self fetchCropDailyGrowingDegreeDays: myCrop.crop];
            Schedule *fSchedule = [Schedule new];
            Schedule *iSchedule = [Schedule new];
            //TODO: change to suggested time after implementing algorithm
            fSchedule.time = [NSDate date]; //temporarily
            iSchedule.time = [NSDate date];
            myCrop.fertilizeSchedule = fSchedule;
            myCrop.irrigateSchedule = iSchedule;
            [myCrop saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable newError) {
                completion(succeeded, newError);
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

+ (void) fetchCropDailyGrowingDegreeDays: (Crop * _Nullable )crop{
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
            //TODO: Assign plant and harvest date to my crop's plantAt and harvestAt
        } else{
            NSLog(@"😫😫😫 Error getting Daily Growing Degree Day: %@", error.localizedDescription);
        }
    }];
    
}


@end
