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
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

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

//For who don't want to login with Facebook account
- (IBAction)loginUserWithParse:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self logInAleartMessage];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
            mySceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}
//For who don't want to register with Facebook account
- (IBAction)registerUserWithParse:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    if([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]){
        NSLog(@"User needs enter valid username and password");
    }
    else{
        // set user properties
        newUser.username = self.usernameTextField.text;
        newUser.password = self.passwordTextField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
            }
        }];
    }
}
- (void) logInAleartMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect username or password"
                                                                   message:@"Please check your username or password to log in again"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // Doing nothing will dismiss the view.
    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

    
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
        NSLog(@"Demo git amend");
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
