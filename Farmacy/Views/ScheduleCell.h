//
//  ScheduleCell.h
//  Farmacy
//
//  Created by Trang Dang on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell/MGSwipeTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tickDoneImageView;

@end

NS_ASSUME_NONNULL_END
