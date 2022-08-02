//
//  Message.h
//  Farmacy
//
//  Created by Trang Dang on 8/1/22.
//

#import <Parse/Parse.h>
#import "Conversation.h"
NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) Conversation *conversation;
@property (nonatomic, strong) PFUser *sender;
@end

NS_ASSUME_NONNULL_END
