//
//  MyCrop.m
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import "MyCrop.h"

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
            [myCrop deleteInBackgroundWithBlock: completion];
        }];
}

@end
