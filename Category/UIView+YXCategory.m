//
//  UIView+YXCategory.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIView+YXCategory.h"
#import <objc/runtime.h>

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

@implementation UIView (YXCategory)

- (CGFloat)yx_minX
{
    return self.frame.origin.x;
}

- (void)setYx_minX:(CGFloat)yx_minX
{
    CGRect frame = self.frame;
    frame.origin.x = yx_minX;
    self.frame = frame;
}

- (CGFloat)yx_minY
{
    return self.frame.origin.y;
}

- (void)setYx_minY:(CGFloat)yx_minY
{
    CGRect frame = self.frame;
    frame.origin.y = yx_minY;
    self.frame = frame;
}

- (CGFloat)yx_maxX
{
    return self.yx_minX+self.yx_width;
}

- (void)setYx_maxX:(CGFloat)yx_maxX
{
    CGRect frame = self.frame;
    frame.size.width = yx_maxX-self.yx_minX;
    self.frame = frame;
}

- (CGFloat)yx_maxY
{
    return self.yx_minY+self.yx_height;
}

- (void)setYx_maxY:(CGFloat)yx_maxY
{
    CGRect frame = self.frame;
    frame.size.height = yx_maxY-self.yx_minY;
    self.frame = frame;
}

- (CGFloat)yx_width
{
    return self.frame.size.width;
}

- (void)setYx_width:(CGFloat)yx_width
{
    CGRect frame = self.frame;
    frame.size.width = yx_width;
    self.frame = frame;
}

- (CGFloat)yx_height
{
    return self.frame.size.height;
}

- (void)setYx_height:(CGFloat)yx_height
{
    CGRect frame = self.frame;
    frame.size.height = yx_height;
    self.frame = frame;
}

- (CGFloat)yx_centerX
{
    return self.center.x;
}

- (void)setYx_centerX:(CGFloat)yx_centerX
{
    CGPoint center = self.center;
    center.x = yx_centerX;
    self.center = center;
}

- (CGFloat)yx_centerY
{
    return self.center.y;
}

- (void)setYx_centerY:(CGFloat)yx_centerY
{
    CGPoint center = self.center;
    center.y = yx_centerY;
    self.center = center;
}

- (void)yx_setGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    [self layoutIfNeeded];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.bounds;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    [self.layer addSublayer:gradientLayer];
}

- (BOOL)yx_isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

- (void)yx_addTapActionWithBlock:(YXGestureActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        YXGestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (void)yx_addLongPressActionWithBlock:(YXGestureActionBlock)block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        YXGestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (UIImage *)yx_screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else
    {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}
@end
