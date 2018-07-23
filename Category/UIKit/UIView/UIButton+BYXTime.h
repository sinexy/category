//
//  UIButton+YXCategory.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ImageViewStyleTop,
    ImageViewStyleLeft,
    ImageViewStyleBottom,
    ImageViewStyleRight,
} ImageViewStyle;

@interface UIButton (BYXTime)

/**
 设置 按钮 图片所在的位置
 
 @param style   图片位置类型（上、左、下、右）
 @param size    图片的大小
 @param space 图片跟文字间的间距
 */
- (void)byx_setImageViewStyle:(ImageViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;


/**
 *  设置倒计时按钮的样式
 *
 *  @param timeout    总时间
 *  @param unitTitle     倒计时的单位
 *  @param startColor 倒计时的颜色
 *  @param endTitle 结束的文字
 *  @param endColor 结束的颜色
 */
- (void)byx_setStartTime:(NSInteger)timeout unit:(NSString *)unitTitle startTitleColor:(UIColor *)startColor endTitle:(NSString *)endTitle endColor:(UIColor *)endColor;

/**
 * 开始倒计时
 */
- (void)byx_startTime;

/**
 * 取消倒计时
 */
- (void)byx_cancelTime;

@end
