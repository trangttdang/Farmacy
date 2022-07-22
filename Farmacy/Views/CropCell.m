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
    UITapGestureRecognizer *addCropTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAddCrop:)];
    [self.addCropIconImageView addGestureRecognizer:addCropTapGestureRecognizer];
    [self.addCropIconImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)didTapAddCrop:(UITapGestureRecognizer *)sender {
    [self.delegate didAddCrop:self.crop];
}

@end
