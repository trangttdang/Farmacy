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
@end

@implementation CropsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cropsTableView.dataSource = self;
    self.cropsTableView.delegate = self;
    [self reloadData:10];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)didAddCrop:(Crop *)crop {
    MyCropsViewController *myCropViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCropsViewController"];
    [Crop addToMyCrops:crop withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
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



@end
