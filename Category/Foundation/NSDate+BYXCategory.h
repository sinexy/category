//
//  NSDate+YXCategory.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YXCategory)

/**
 * 获取两个时间的天数差
 @param firstDate 第一个时间
 @param secondDate 第二个时间
 @return 比较得出的天数差
 */
+ (NSInteger)yx_getDateFormDate:(NSDate *)firstDate toDate:(NSDate *)secondDate;


+ (NSInteger)yx_getDateToDateDays:(NSDate *)firstDate withSaveDate:(NSDate *)secondDate;
/**
 * 获取当前年月日
 */
+ (NSString *)yx_getCurrentYearMonthDay;
/**
 * 获取当前时间戳
 */
+ (NSString *)yx_getNowTimeTimestamp;

@end
