//
//  NSString+Category.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (BYXSize)

/**
 * @biref 计算文字高度
 * @param fontSize 文字大小
 * @param width 控件宽度
 * @return 控件高度
 */
- (CGFloat)yx_stringHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

/**
 * @biref 计算文字高度
 * @param width 控件宽度
 * @return 控件高度
 */
- (CGFloat)yx_stringHeightWithFont:(UIFont *)font width:(CGFloat)width;

/** 判断是否未数字（可以是小数）*/
- (BOOL)yx_isNumber;

/** 身份证号码格式校验 */
- (BOOL)yx_isIdentification;

/** 手机号码校验 */
- (BOOL)yx_isPhoneNumber;

/** 去除字符串中的空格 */
- (instancetype)yx_stringWithNoSpaceCharacterSet;

// 将不完整的base64 转为完整的
- (instancetype)yx_stringPaddedForBase64;


/** 32位小写加密 */
- (instancetype)yx_md532BitLower;
/** 32位大写加密 */
- (instancetype)yx_md532BitUpper;
/** 时间戳转年月日*/
- (instancetype)yx_timeStampString2Date;
/** 时间戳转年月日时分秒*/
- (NSString *)yx_timeStampString2Time;


@end
