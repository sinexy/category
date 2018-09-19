//
//  NSData+BYXAPNSToken.h
//  BYXCategories
//
//  Created by bai on 15/8/7.
//

#import <Foundation/Foundation.h>

@interface NSData (BYXAPNSToken)
/**
 *  @brief  将APNS NSData类型token 格式化成字符串
 *
 *  @return 整理过后的字符串token
 */
- (NSString *)byx_APNSToken;
@end
