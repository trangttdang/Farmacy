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
        
        SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyCropsViewController"];
        mySceneDelegate.window.rootViewController = loginViewController;
        
    }
}


@end
