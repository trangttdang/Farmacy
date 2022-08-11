//
//  MyCropsViewController.h
//  Farmacy
//
//  Created by Trang Dang on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "Crop.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCropsViewController : UIViewController
@property (nonatomic) Crop *crop;

@end

NS_ASSUME_NONNULL_END
