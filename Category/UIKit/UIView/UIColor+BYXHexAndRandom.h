//
//  UIColor+BYXHexAndRandom.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BYXHexAndRandom)

/**
 * @biref 将16进制颜色 转换为 RGB 颜色
 * @return UIColor
 */
+ (instancetype)byx_colorWithHexString:(NSString *)hex;

/**
 * @biref 生成随机颜色
 * @return UIColor
 */
+ (instancetype)byx_randomColor;

@end
