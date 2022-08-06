//
//  MyCrop.m
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import "MyCrop.h"
#import "IrrigateSchedule.h"
@implementation MyCrop
@dynamic progressPercentage;
@dynamic irrigateIntervalDays;
@dynamic plantedAt;
@dynamic harvestedAt;
@dynamic fertilizeSchedule;
@dynamic irrigateSchedule;
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

@end
