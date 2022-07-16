//
//  CropDetailViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/14/22.
//

#import "CropDetailViewController.h"
#import "Parse/PFImageView.h"


@interface CropDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cropNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropProgressPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropTypeByUseLabel;

@property (weak, nonatomic) IBOutlet PFImageView *cropImageView;

@end

@implementation CropDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyCrop *myCrop = self.myCrop;
    Crop *crop = myCrop[@"crop"];
    
    [crop fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        } else {
            NSLog(@"%@", @"Fetch crop sucessfully");
            self.cropNameLabel.text = crop[@"name"];
            self.cropTypeByUseLabel.text = crop[@"typeByUse"];
            self.cropImageView.file = crop[@"image"];
            [self.cropImageView loadInBackground];
        }
    }];
    
    self.cropProgressPercentageLabel.text = [[NSString stringWithFormat:@"%d", myCrop.progressPercentage]stringByAppendingString: @"%"];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
