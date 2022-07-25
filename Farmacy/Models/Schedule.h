//
//  Schedule.h
//  Farmacy
//
//  Created by Trang Dang on 7/15/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Schedule : PFObject<PFSubclassing>

@property (nonatomic,strong) NSDate *time;
@end

NS_ASSUME_NONNULL_END
