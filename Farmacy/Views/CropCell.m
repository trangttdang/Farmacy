//
//  CropCell.m
//  Farmacy
//
//  Created by Trang Dang on 7/13/22.
//

#import "CropCell.h"

@implementation CropCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *addCropTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAddOrRemoveCrop:)];
    [self.addOrRemoveCropIconImageView addGestureRecognizer:addCropTapGestureRecognizer];
    [self.addOrRemoveCropIconImageView setUserInteractionEnabled:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)didTapAddOrRemoveCrop:(UITapGestureRecognizer *)sender {
    Crop *crop = self.crop;
    if(crop.isMyCrop == 1){
        [self.delegate didRemoveCrop:self.crop];
    } else{
        [self.delegate didAddCrop:self.crop];
    }
}

@end
