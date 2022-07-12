//
//  MyCropsViewController.h
//  Farmacy
//
//  Created by Trang Dang on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "FBSDKLoginKit/FBSDKLoginKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCropsViewController : UIViewController <FBSDKLoginButtonDelegate>;
@property (weak, nonatomic) IBOutlet UIView *fbLogoutButtonView;

@end

NS_ASSUME_NONNULL_END
