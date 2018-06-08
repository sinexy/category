//
//  NSDate+YXCategory.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "NSDate+YXCategory.h"

@implementation NSDate (YXCategory)
/**
 * 获取两个时间的天数差
 @param firstDate 第一个时间
 @param secondDate 第二个时间
 @return 比较得出的天数差
 */
+ (NSInteger)yx_getDateFormDate:(NSDate *)firstDate toDate:(NSDate *)secondDate {
    NSUInteger dii = abs([secondDate timeIntervalSince1970] - [firstDate timeIntervalSince1970]);
    NSInteger diffDay = dii/(60*60*24);
    return diffDay;
}

+ (NSInteger)yx_getDateToDateDays:(NSDate *)firstDate withSaveDate:(NSDate *)secondDate {
    NSCalendar* chineseClendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags        = NSCalendarUnitYear | NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *cps       = [chineseClendar components:unitFlags fromDate:firstDate toDate:secondDate  options:0];
    NSInteger diffDay           = [cps day];
    return diffDay;
}

+ (NSString *)yx_getCurrentYearMonthDay
{
    NSDate *date               = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

+ (NSString *)yx_getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
@end
