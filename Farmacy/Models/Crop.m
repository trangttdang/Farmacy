//
//  Crop.m
//  Farmacy
//
//  Created by Trang Dang on 7/12/22.
//

#import "Crop.h"

@implementation Crop

@dynamic cropID;
@dynamic name;
@dynamic typeByUse;
@dynamic image;
@dynamic plantedAt;
@dynamic harvestedAt;
@dynamic progressPercentage;
@dynamic nextIrrigate;
@dynamic nextFertilize;
@dynamic isMyCrop;

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
    PFQuery *query = [PFQuery queryWithClassName:@"Crop"];
    NSString *cropObjectID = crop.objectId;
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:cropObjectID
                                 block:^(PFObject *crop, NSError *error) {
        crop[@"isMyCrop"] = @YES;
        [crop saveInBackground];
    }];
    
}

+ (void) removeFromMyCrops: (Crop * _Nullable )crop withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Crop"];
    NSString *cropObjectID = crop.objectId;
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:cropObjectID
                                 block:^(PFObject *crop, NSError *error) {
        crop[@"isMyCrop"] = @NO;
        [crop saveInBackground];
    }];
}

@end
