//
//  HarvestedCropsViewController.m
//  Farmacy
//
//  Created by Trang Dang on 8/11/22.
//
#import "MyCrop.h"
#import "MyCropCell.h"
#import "HarvestedCropsViewController.h"
#import <STPopup/STPopup.h>
#import "CropDetailViewController.h"
@interface HarvestedCropsViewController () <MyCropCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *harvestedTableView;
@property (strong, nonatomic) NSArray *arrayOfHarvestedCrops;
@end

@implementation HarvestedCropsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.harvestedTableView.delegate = self;
    self.harvestedTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
   [self reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCropCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CropCell" forIndexPath:indexPath];
    MyCrop *myCrop = self.arrayOfHarvestedCrops[indexPath.row];
    cell.myCropNameLabel.text = myCrop.crop.name;
    cell.myCropTypeByUseLabel.text = myCrop.crop.typeByUse;
    cell.myCropImageView.file = myCrop.crop.image;
    [cell.myCropImageView loadInBackground];
    cell.myCropImageView.layer.cornerRadius = 5;
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
    //set up circular pogress bar
    cell.progressBar.maxValue = 100;
    cell.progressBar.progressColor = [UIColor colorWithRed:(100/255.0) green:(85/255.0) blue:(188/255.0) alpha:1];
    cell.progressBar.progressStrokeColor = [UIColor colorWithRed:(100/255.0) green:(85/255.0) blue:(188/255.0) alpha:1];
    cell.progressBar.progressLineWidth = 3;
    cell.progressBar.fontColor = [UIColor blackColor];
    [UIView animateWithDuration:1.f animations:^{
        cell.progressBar.value = myCrop.progressPercentage;
    }];
    cell.plantedAtLabel.text = [formatter stringFromDate:myCrop.plantedAt.time];
    cell.delegate = self;
    cell.removeCropIconImageView.image = [UIImage imageNamed:@"minus"];
    cell.cardView.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.cardView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    cell.cardView.layer.shadowOpacity = 0.5;
    cell.cardView.layer.masksToBounds = false;
    cell.cardView.layer.cornerRadius = 5;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.arrayOfHarvestedCrops.count;
}

- (void)reloadData{
   //  construct query
    PFQuery *query = [PFQuery queryWithClassName:@"MyCrop"];
    [query whereKey:@"farmer" equalTo:[PFUser currentUser]];
    [query whereKey:@"progressPercentage" equalTo:@100];
    [query includeKey:@"crop"];
    [query includeKey:@"fertilizeSchedule"];
    [query includeKey:@"irrigateSchedule"];
    [query includeKey:@"plantedAt"];
    [query includeKey:@"harvestedAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *myCrops, NSError *error) {
        if (myCrops != nil) {
            self.arrayOfHarvestedCrops = myCrops;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.harvestedTableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CropDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CropDetailViewController"];
    MyCrop *myCrop = self.arrayOfHarvestedCrops[indexPath.row];
    viewController.myCrop = myCrop;
//    [self.navigationController pushViewController: viewController animated:YES];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:viewController];
    popupController.style = STPopupStyleBottomSheet;
    viewController.contentSizeInPopup = CGSizeMake(400, 400);
    viewController.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    [popupController presentInViewController:self];
    
}


@end
