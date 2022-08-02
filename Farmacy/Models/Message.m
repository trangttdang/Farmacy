//
//  Message.m
//  Farmacy
//
//  Created by Trang Dang on 8/1/22.
//

#import "Message.h"

@implementation Message
@dynamic text;
@dynamic conversation;
@dynamic sender;
+ (NSString *)parseClassName {
  return @"Message";
}
@end
