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
                completion(succeeded, newError);
            }];
        }];
}

+ (MyCrop *)getMyCropUsingSchedule:(Schedule *)schedule{
    PFQuery *iQuery = [PFQuery queryWithClassName:@"MyCrop"];
    PFQuery *fQuery = [PFQuery queryWithClassName:@"MyCrop"];
    PFQuery *pQuery = [PFQuery queryWithClassName:@"MyCrop"];
    PFQuery *hQuery = [PFQuery queryWithClassName:@"MyCrop"];
    [iQuery whereKey:@"irrigateSchedule" equalTo:schedule];
    [fQuery whereKey:@"fertilizeSchedule" equalTo:schedule];
    [pQuery whereKey:@"plantedAt" equalTo:schedule];
    [hQuery whereKey:@"harvestedAt" equalTo:schedule];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[iQuery ,fQuery, pQuery, hQuery]];
    [query includeKey:@"crop"];
    [query includeKey:@"irrigateSchedule"];
    [query includeKey:@"fertilizeSchedule"];
    [query includeKey:@"plantedAt"];
    [query includeKey:@"harvestedAt"];
    
    return [query getFirstObject];
}

@end
