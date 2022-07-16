//
//  Crop.m
//  Farmacy
//
//  Created by Trang Dang on 7/12/22.
//

#import "Crop.h"
#import "MyCrop.h"

@implementation Crop

@dynamic name;
@dynamic typeByUse;
@dynamic image;


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
            myCrop[@"crop"] = crop;
            myCrop[@"progressPercentage"] = @(0);
            
            [myCrop saveInBackgroundWithBlock: completion];
        } else if (error == nil){
            NSLog(@"Crop is already added");
        } else{
            NSLog(@"Unknown error %@", error.localizedDescription);
        }
    }];
    
}



@end
