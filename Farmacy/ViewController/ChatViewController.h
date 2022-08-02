//
//  ChatViewController.h
//  Farmacy
//
//  Created by Trang Dang on 7/16/22.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (nonatomic, strong) Conversation *conversation;

@end

NS_ASSUME_NONNULL_END
