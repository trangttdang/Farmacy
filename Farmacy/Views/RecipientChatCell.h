//
//  RecipientChatCell.h
//  Farmacy
//
//  Created by Trang Dang on 8/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipientChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *sentAtLabel;

@end

NS_ASSUME_NONNULL_END
