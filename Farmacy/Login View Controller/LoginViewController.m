//
//  LoginViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/7/22.
//

#import "LoginViewController.h"
#import "MyCropsViewController.h"

#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
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
    [self.fbLoginButtonView addSubview:loginButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FBSDKLoginButton Delegate Methods

- (void)loginButton:(FBSDKLoginButton * _Nonnull)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult * _Nullable)result error:(NSError * _Nullable)error{
    if(error){
        NSLog(@"%@", error.localizedDescription);
    }
    if (result.isCancelled){
        NSLog(@"User cancel to log in");
    } else if (result.declinedPermissions.count > 0){
        NSLog(@"User has declined permissions");
    } else{
        NSLog(@"User successfully log in");
        //Navigate to next view
        MyCropsViewController *myCropsViewController = [[MyCropsViewController alloc] initWithNibName:@"MyCropsViewController" bundle:nil];
        UINavigationController *navigateController = [[UINavigationController alloc] initWithRootViewController:myCropsViewController];
        [self presentViewController:navigateController animated:YES completion:nil];
        
    }
}

@end
