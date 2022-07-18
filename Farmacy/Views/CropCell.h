//
//  CropCell.h
//  Farmacy
//
//  Created by Trang Dang on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Crop.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CropCellDelegate
- (void)didAddCrop: (Crop *) crop;
- (void)didRemoveCrop: (Crop *) crop;
@end

@interface CropCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cropNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropTypeByUseLabel;
@property (weak, nonatomic) IBOutlet PFImageView *cropImageView;

@property (weak, nonatomic) IBOutlet UIImageView *addOrRemoveCropIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressPercentageLabel;

@property (nonatomic,weak) id<CropCellDelegate> delegate;
@property (nonatomic, strong) Crop *crop;


@end

NS_ASSUME_NONNULL_END
