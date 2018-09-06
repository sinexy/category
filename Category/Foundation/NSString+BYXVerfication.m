//
//  NSString+Category.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "NSString+YXCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BYXVerfication)


- (BOOL)byx_isNumber
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]\\d*\\.?\\d*|0\\.\\d*[0-9]\\d*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)byx_isIdentification
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)byx_isPhoneNumber
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}


- (instancetype)stringWithNoSpaceCharacterSet
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

- (instancetype)byx_stringPaddedForBase64
{
    NSUInteger paddedLength = self.length + (self.length % 3);
    return [self stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
}

- (instancetype)byx_md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (instancetype)byx_md532BitUpper
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

- (instancetype)byx_timeStampString2Date
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [self doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

- (instancetype)timeStampString2Time
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [self doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
@end
