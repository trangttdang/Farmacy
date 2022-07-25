//
//  MyCropsViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/7/22.
//

#import "MyCropsViewController.h"
#import "LoginViewController.h"
#import "CropsViewController.h"
#import "CropDetailViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "MyCrop.h"
#import "MyCropCell.h"

#import "FBSDKCoreKit/FBSDKProfile.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"

@interface MyCropsViewController () <MyCropCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myCropsTableView;
@property (strong, nonatomic) NSArray *arrayOfMyCrops;

@end

@implementation MyCropsViewController
@synthesize fbLogoutButtonView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self checkProfile];
    self.myCropsTableView.delegate = self;
    self.myCropsTableView.dataSource = self;
    [self reloadData];
}



- (void) checkProfile{
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

- (void)loginButtonDidLogOut:(FBSDKLoginButton * _Nonnull)logoutButton{
    NSLog(@"User log out");
    SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mySceneDelegate.window.rootViewController = loginViewController;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCropCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CropCell" forIndexPath:indexPath];
    MyCrop *myCrop = self.arrayOfMyCrops[indexPath.row];
    cell.myCropNameLabel.text = myCrop.crop.name;
    cell.myCropTypeByUseLabel.text = myCrop.crop.typeByUse;
    cell.myCropImageView.file = myCrop.crop.image;
    [cell.myCropImageView loadInBackground];
    cell.myCropImageView.layer.cornerRadius = 10;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    [formatter setDateFormat: @"E MMM d HH:mm:ss Z y"];
    //Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    cell.nextFertilizeLabel.text = [formatter stringFromDate:myCrop.fertilizeSchedule.time];
    cell.nextIrrigateLabel.text = [formatter stringFromDate:myCrop.irrigateSchedule.time];
    
    cell.myCrop = myCrop;
    cell.myCropProgressPercentageLabel.text = [[NSString stringWithFormat:@"%d", myCrop.progressPercentage]stringByAppendingString: @"%"];
    cell.plantedAtLabel.text = [formatter stringFromDate:myCrop.plantedAt];
    cell.delegate = self;
    cell.removeCropIconImageView.image = [UIImage imageNamed:@"minus"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMyCrops.count;
}

- (void)reloadData{
   //  construct query
    PFQuery *query = [PFQuery queryWithClassName:@"MyCrop"];
    [query includeKey:@"crop"];
    [query includeKey:@"fertilizeSchedule"];
    [query includeKey:@"irrigateSchedule"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *myCrops, NSError *error) {
        if (myCrops != nil) {
            self.arrayOfMyCrops = myCrops;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.myCropsTableView reloadData];
    }];
}

- (void)didRemoveCrop:(MyCrop *)myCrop {
    CropsViewController *cropViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CropsViewController"];
    [MyCrop removeFromMyCrops:myCrop withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error removing Crop: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Removing Crop from My Crops Success!");
            [self reloadData];
            [self.navigationController pushViewController:cropViewController animated:YES];
        }
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CropDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CropDetailViewController"];
    MyCrop *myCrop = self.arrayOfMyCrops[indexPath.row];
    viewController.myCrop = myCrop;
    [self.navigationController pushViewController: viewController animated:YES];
}
- (IBAction)didTapChat:(id)sender {
    ChatViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    [self.navigationController pushViewController: viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CropDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CropDetailViewController"];
    MyCrop *myCrop = self.arrayOfMyCrops[indexPath.row];
    viewController.myCrop = myCrop;
    [self.navigationController pushViewController: viewController animated:YES];
}
- (IBAction)didTapChat:(id)sender {
    ChatViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    [self.navigationController pushViewController: viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CropDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CropDetailViewController"];
    Crop *crop = self.arrayOfMyCrops[indexPath.row];
    viewController.crop = crop;
    [self.navigationController pushViewController: viewController animated:YES];
}

@end
