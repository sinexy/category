//
//  NSData+BYXAPNSToken.m
//  BYXCategories
//
//  Created by bai on 15/8/7.
//

#import "NSData+BYXAPNSToken.h"

@implementation NSData (BYXAPNSToken)
/**
 *  @brief  将APNS NSData类型token 格式化成字符串
 *
 *  @return 字符串token
 */
- (NSString *)byx_APNSToken {
    return [[[[self description]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
