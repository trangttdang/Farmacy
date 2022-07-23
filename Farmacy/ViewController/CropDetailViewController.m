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
    self.cropNameLabel.text = myCrop.crop.name;
    self.cropTypeByUseLabel.text = myCrop.crop.typeByUse;
    self.cropImageView.file = myCrop.crop.image;
    [self.cropImageView loadInBackground];
    
    self.cropProgressPercentageLabel.text = [[NSString stringWithFormat:@"%d", myCrop.progressPercentage]stringByAppendingString: @"%"];
    
}




@end
