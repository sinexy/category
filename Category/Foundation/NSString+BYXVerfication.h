//
//  NSString+Category.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (BYXVerfication)

/** 判断是否未数字（可以是小数）*/
- (BOOL)byx_isNumber;

/** 身份证号码格式校验 */
- (BOOL)byx_isIdentification;

/** 手机号码校验 */
- (BOOL)byx_isPhoneNumber;

/** 去除字符串中的空格 */
- (instancetype)byx_stringWithNoSpaceCharacterSet;

// 将不完整的base64 转为完整的
- (instancetype)byx_stringPaddedForBase64;


/** 32位小写加密 */
- (instancetype)byx_md532BitLower;
/** 32位大写加密 */
- (instancetype)byx_md532BitUpper;
/** 时间戳转年月日*/
- (instancetype)byx_timeStampString2Date;
/** 时间戳转年月日时分秒*/
- (NSString *)byx_timeStampString2Time;


@end
