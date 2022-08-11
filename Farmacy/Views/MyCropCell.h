//
//  MyCropCell.h
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "MyCrop.h"
#import "MBCircularProgressBar/MBCircularProgressBarView.h"


NS_ASSUME_NONNULL_BEGIN
@protocol MyCropCellDelegate
-(void) didRemoveCrop: (MyCrop *) mycrop;
@end

@interface MyCropCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myCropNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCropTypeByUseLabel;
@property (weak, nonatomic) IBOutlet PFImageView *myCropImageView;
@property (weak, nonatomic) IBOutlet UILabel *myCropProgressPercentageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *removeCropIconImageView;
@property (weak, nonatomic) id<MyCropCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nextFertilizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextIrrigateLabel;
@property (weak, nonatomic) IBOutlet UILabel *plantedAtLabel;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (nonatomic) MyCrop *myCrop;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@end

NS_ASSUME_NONNULL_END
