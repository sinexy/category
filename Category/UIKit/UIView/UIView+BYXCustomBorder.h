//
//  UIView+BYXCustomBorder.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/22.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, BYXExcludePoint) {
    BYXExcludePointStart = 1 << 0,
    BYXExcludePointEnd = 1 << 1,
    BYXExcludePointAll = ~0UL
};

@interface UIView (BYXCustomBorder)

- (void)byx_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;
- (void)byx_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;
- (void)byx_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;
- (void)byx_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;

- (void)byx_removeTopBorder;
- (void)byx_removeLeftBorder;
- (void)byx_removeBottomBorder;
- (void)byx_removeRightBorder;

- (void)byx_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(BYXExcludePoint)edge;
- (void)byx_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(BYXExcludePoint)edge;
- (void)byx_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(BYXExcludePoint)edge;
- (void)byx_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(BYXExcludePoint)edge;

@end

NS_ASSUME_NONNULL_END
