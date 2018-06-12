//
//  UIImage+Category.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 返回一张没有被渲染的图片
 
 @param imageName  图片名称
 @return 一张没有被渲染的图片
 */
+ (instancetype)yx_imageWithOriginal:(NSString *)imageName;

/**
 根据颜色返回一张图片
 
 @param color 颜色
 @return 图片
 */
+ (instancetype)yx_imageWithColor:(UIColor *)color;


@end
