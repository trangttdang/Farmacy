//
//  CropDetectionViewController.m
//  Farmacy
//
//  Created by Trang Dang on 8/12/22.
//

#import "CropDetectionViewController.h"
#import "MobileNetV2.h"
@interface CropDetectionViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cropDetectImageView;
@property (strong, nonatomic) UIImage *cropDetectionImage;
@property (weak, nonatomic) IBOutlet UILabel *cropDetectionResult;

@end

@implementation CropDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPicture];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    // Do any additional setup after loading the view.
}
- (void)getPicture{
    // Do any additional setup after loading the view.
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // Instantiate a UIImagePickerController
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.cropDetectionImage = [self resizeImage:originalImage withSize:CGSizeMake(224, 224)];
    
    [self.cropDetectImageView setImage:self.cropDetectionImage];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self detect];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void) detect{
    CGImageRef imgage = self.cropDetectionImage.CGImage;
    MLPredictionOptions* options = [MLPredictionOptions new];
    MobileNetV2 *mo = [[MobileNetV2 alloc]init];
    MobileNetV2Input *input = [[MobileNetV2Input alloc]initWithImageFromCGImage:imgage error:nil];
    NSArray <MobileNetV2Output *> *arr = [[NSArray alloc]init];
    arr = [mo predictionsFromInputs:@[input] options:options error:nil];
    for(MobileNetV2Output *output in arr){
        NSLog(@"%@", output.classLabel);
        self.cropDetectionResult.text = [NSString stringWithFormat:@"%@", output.classLabel];
    }
}

@end
