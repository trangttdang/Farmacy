//
//  CropsViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/13/22.
//

#import "CropsViewController.h"
#import "CropCell.h"
#import "MyCropsViewController.h"
#import "CropRecommendation.h"
#import "InputRecommendationFormViewController.h"
#import <STPopup/STPopup.h>
#import "JHUD.h"
@interface CropsViewController () <CropCellDelegate, UITableViewDelegate, UITableViewDataSource,InputRecomMendationFormDelegate>;
@property (weak, nonatomic) IBOutlet UITableView *cropsTableView;
@property (strong, nonatomic) NSArray *arrayOfCrops;
@property (strong, nonatomic) NSMutableArray *arrayOfSeenIndexes;
@property (strong, nonatomic) JHUD *hudView;
@end

@implementation CropsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self activateInputForm];
    // Do any additional setup after loading the view.
    self.cropsTableView.dataSource = self;
    self.cropsTableView.delegate = self;
    self.arrayOfSeenIndexes = [[NSMutableArray alloc] init];
}

- (void)activateInputForm{
    //Input Info for recommendation
    InputRecommendationFormViewController *inputRecFormVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InputRecommendationFormViewController"];
    inputRecFormVC.delegate = self;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:inputRecFormVC];
    popupController.style = STPopupStyleFormSheet;
    inputRecFormVC.contentSizeInPopup = CGSizeMake(300, 400);
    inputRecFormVC.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    [popupController presentInViewController:self];
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
    if (crop.recommendationRate > 0){
        cell.recommendedImageView.hidden = false;
    } else{
        cell.recommendedImageView.hidden = true;
    }
    cell.cropNameLabel.text = crop.name;
    cell.cropTypeByUseLabel.text = crop.typeByUse;
    cell.cropImageView.file = crop.image;
    cell.cropImageView.layer.cornerRadius = 10;
    cell.cropImageView.clipsToBounds = YES;
    [cell.cropImageView loadInBackground];
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
    [query orderByDescending:@"recommendationRate"];
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


- (void)didMakeCropRecommendation:(double)nitrogenRatio withPhosphorousRatio:(double)phosphorousRatio withPotassiumRatio:(double)potassiumRatio withPh:(double)ph withRainfallAmount:(double)rainFallAmount withTemperature:(double)avgTemp withHumidity:(double)avgHumidity{
    CropRecommendation *model = [[CropRecommendation alloc]init];
    CropRecommendationOutput *cropRecommendationOutput = [model predictionFromN:nitrogenRatio P:phosphorousRatio K:potassiumRatio temperature:avgTemp humidity:avgHumidity ph:ph rainfall:rainFallAmount error:nil];
    NSDictionary<NSString *, NSNumber *> * results = cropRecommendationOutput.labelProbability;
    NSArray *labelsRecommedation = [results keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj2 compare:obj1];
    }];
    NSArray *topRecommendation= [labelsRecommedation subarrayWithRange:NSMakeRange(0, 5)];
    PFQuery *query = [PFQuery queryWithClassName:@"Crop"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for(Crop *crop in objects){
            crop.recommendationRate = 0;
            if ([topRecommendation containsObject:[crop.name lowercaseString]]){
                crop.recommendationRate = (int)([topRecommendation indexOfObject:[crop.name lowercaseString]]+1);
            }
            [crop saveInBackground];
        }
        [self loadingAnimation];
        [self reloadData:10];
    }];
}

- (void)loadingAnimation{
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"growing-plant" ofType:@"gif"];
    self.hudView.gifImageData = [NSData dataWithContentsOfFile:path];
    self.hudView.indicatorViewSize = CGSizeMake(200, 200);
    self.hudView.messageLabel.text = @"Planting..";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
    [self.hudView hideAfterDelay:2.5];
}
@end
