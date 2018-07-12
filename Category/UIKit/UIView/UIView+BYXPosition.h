//
//  UIView+YXCategory.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYXGestureActionBlock)(UIGestureRecognizer *gestureRecognizer);
@interface UIView (BYXPosition)

@property (nonatomic, assign) CGFloat byx_minX;
@property (nonatomic, assign) CGFloat byx_minY;
@property (nonatomic, assign) CGFloat byx_maxX;
@property (nonatomic, assign) CGFloat byx_maxY;
@property (nonatomic, assign) CGFloat byx_width;
@property (nonatomic, assign) CGFloat byx_height;
@property (nonatomic, assign) CGFloat byx_centerX;
@property (nonatomic, assign) CGFloat byx_centerY;

/**
 * @biref   设置渐变色
 * 此方法在布局后调用
 * button 上有 bug， 如果用 masonry 布局可能出现设置了文字而不显示的 bug
 * @param startColor 开始颜色
 * @param endColor 结束颜色
 */
- (void)byx_setGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/**
 * @brief 判断一个控件是否真正显示在主窗口
 */
- (BOOL)byx_isShowingOnKeyWindow;

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)byx_addTapActionWithBlock:(YXGestureActionBlock)block;

/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)byx_addLongPressActionWithBlock:(BYXGestureActionBlock)block;

/**
 *  @brief  view截图
 *
 *  @return 截图
 */
- (UIImage *)byx_screenshot;

@end
