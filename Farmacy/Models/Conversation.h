//
//  Conversation.h
//  Farmacy
//
//  Created by Trang Dang on 8/1/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *userOne;
@property (nonatomic, strong) PFUser *userTwo;
@end

NS_ASSUME_NONNULL_END
