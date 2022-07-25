//
//  LoginViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/7/22.
//

#import "LoginViewController.h"
#import "MyCropsViewController.h"
#import "SceneDelegate.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import <PFFacebookUtils.h>
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize fbLoginButtonView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc]init];
    loginButton.delegate = self;
    loginButton.center = fbLoginButtonView.center;
    loginButton.permissions = @[@"public_profile", @"email"];
    [self.view addSubview:loginButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
- (void)loginButton:(FBSDKLoginButton * )loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult * )result error:(NSError * )error{
    if(error){
        NSLog(@"%@", error.localizedDescription);
    }
    if (result.isCancelled){
        NSLog(@"User cancel to log in");
    } else if (result.declinedPermissions.count > 0){
        NSLog(@"User has declined permissions");
    } else{
        NSLog(@"User successfully log in");
        
        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken]; // Use existing access token.

        // Log In (create/update currentUser) with FBSDKAccessToken
        [PFFacebookUtils logInInBackgroundWithAccessToken:accessToken
                                                    block:^(PFUser *user, NSError *error) {
          if (!user) {
            NSLog(@"Uh oh. There was an error logging in.");
          } else {
            NSLog(@"User logged in through Facebook!");
              SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
              mySceneDelegate.window.rootViewController = loginViewController;
          }
        }];
        
    }
}

@end
