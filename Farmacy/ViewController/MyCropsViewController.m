//
//  MyCropsViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/7/22.
//

#import "MyCropsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"

#import "FBSDKCoreKit/FBSDKProfile.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"

@interface MyCropsViewController ()

@end

@implementation MyCropsViewController
@synthesize fbLogoutButtonView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if(profile){
                FBSDKLoginButton *logoutButton = [[FBSDKLoginButton alloc]init];
                logoutButton.delegate = self;
                logoutButton.center = self.fbLogoutButtonView.center;
                [self.view addSubview:logoutButton];
                
            }
        }];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loginButtonDidLogOut:(FBSDKLoginButton * _Nonnull)logoutButton{
    NSLog(@"User log out");
    SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mySceneDelegate.window.rootViewController = loginViewController;
    
    
}

@end
