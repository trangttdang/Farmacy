//
//  CropsViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/13/22.
//

#import "CropsViewController.h"
#import "CropCell.h"
#import "MyCropsViewController.h"

@interface CropsViewController () <CropCellDelegate, UITableViewDelegate, UITableViewDataSource>;
@property (weak, nonatomic) IBOutlet UITableView *cropsTableView;
@property (strong, nonatomic) NSArray *arrayOfCrops;
@property (strong, nonatomic) NSMutableArray *arrayOfSeenIndexes;

@end

@implementation CropsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cropsTableView.dataSource = self;
    self.cropsTableView.delegate = self;
    [self reloadData:10];
    self.arrayOfSeenIndexes = [[NSMutableArray alloc] init];
}


- (void)didAddCrop:(Crop *)crop {
    MyCropsViewController *myCropViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCropsViewController"];
    [Crop addToMyCrops:crop withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded == false || error){
            NSLog(@"Error adding Crop: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Add Crop to My Crops Success!");
            [self reloadData:10];
            [self.navigationController pushViewController:myCropViewController animated:YES];
        }
    }];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CropCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CropCell" forIndexPath:indexPath];
    Crop *crop = self.arrayOfCrops[indexPath.row];
    
    cell.cropNameLabel.text = crop.name;
    cell.cropTypeByUseLabel.text = crop.typeByUse;
    cell.cropImageView.file = crop.image;
    cell.cropImageView.layer.cornerRadius = 10;
    cell.cropImageView.clipsToBounds = YES;
    [cell.cropImageView loadInBackground];
    //TODO: Add more information about crop later with APIs

    cell.crop = crop;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCrops.count;
}

- (void)reloadData: (NSInteger)count{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Crop"];
    query.limit = count;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *crops, NSError *error) {
        if (crops != nil) {
            self.arrayOfCrops = crops;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.cropsTableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.arrayOfSeenIndexes containsObject:indexPath]){
        [self.arrayOfSeenIndexes addObject:indexPath];
        cell.transform = CGAffineTransformMakeTranslation(0, cell.frame.size.height*1.4);
        [UIView animateWithDuration:0.85 delay:0.03*indexPath.row options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            if(finished){
                NSLog(@"Animated My Crop Table View");
            }
        }];
    }
    //Infinite scrolling
    if(indexPath.row + 1 == [self.arrayOfCrops count]){
        [self reloadData:[self.arrayOfCrops count] + 20];
    }
}

@end
