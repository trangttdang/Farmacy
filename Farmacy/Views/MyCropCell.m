//
//  MyCropCell.m
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import "MyCropCell.h"

@implementation MyCropCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *removeCropTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapRemoveMyCrop:)];
    [self.removeCropIconImageView addGestureRecognizer:removeCropTapGestureRecognizer];
    [self.removeCropIconImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)didTapRemoveMyCrop:(UITapGestureRecognizer *)sender {
    [self.delegate didRemoveCrop:self.myCrop];
    
}

@end
