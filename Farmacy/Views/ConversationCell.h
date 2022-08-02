//
//  ConversationCell.h
//  Farmacy
//
//  Created by Trang Dang on 8/1/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ConversationCellDelegate
@end
@interface ConversationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) id<ConversationCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
