//
//  ScheduleCell.h
//  Farmacy
//
//  Created by Trang Dang on 7/20/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
