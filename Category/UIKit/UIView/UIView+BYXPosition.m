//
//  UIView+YXCategory.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIView+BYXPosition.h"
#import <objc/runtime.h>

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

@implementation UIView (BYXPosition)

- (CGFloat)byx_minX
{
    return self.frame.origin.x;
}

- (void)setByx_minX:(CGFloat)byx_minX
{
    CGRect frame = self.frame;
    frame.origin.x = byx_minX;
    self.frame = frame;
}

- (CGFloat)byx_minY
{
    return self.frame.origin.y;
}

- (void)setByx_minY:(CGFloat)byx_minY
{
    CGRect frame = self.frame;
    frame.origin.y = byx_minY;
    self.frame = frame;
}

- (CGFloat)byx_maxX
{
    return self.byx_minX+self.byx_width;
}

- (void)setByx_maxX:(CGFloat)byx_maxX
{
    CGRect frame = self.frame;
    frame.size.width = byx_maxX-self.byx_minX;
    self.frame = frame;
}

- (CGFloat)byx_maxY
{
    return self.byx_minY+self.byx_height;
}

- (void)setByx_maxY:(CGFloat)byx_maxY
{
    CGRect frame = self.frame;
    frame.size.height = byx_maxY-self.byx_minY;
    self.frame = frame;
}

- (CGFloat)byx_width
{
    return self.frame.size.width;
}

- (void)setByx_width:(CGFloat)byx_width
{
    CGRect frame = self.frame;
    frame.size.width = byx_width;
    self.frame = frame;
}

- (CGFloat)byx_height
{
    return self.frame.size.height;
}

- (void)setByx_height:(CGFloat)byx_height
{
    CGRect frame = self.frame;
    frame.size.height = byx_height;
    self.frame = frame;
}

- (CGFloat)byx_centerX
{
    return self.center.x;
}

- (void)setByx_centerX:(CGFloat)byx_centerX
{
    CGPoint center = self.center;
    center.x = byx_centerX;
    self.center = center;
}

- (CGFloat)byx_centerY
{
    return self.center.y;
}

- (void)setByx_centerY:(CGFloat)byx_centerY
{
    CGPoint center = self.center;
    center.y = byx_centerY;
    self.center = center;
}

- (void)byx_setGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
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

- (BOOL)byx_isShowingOnKeyWindow
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

- (void)byx_addTapActionWithBlock:(BYXGestureActionBlock)block
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

- (void)byx_addLongPressActionWithBlock:(BYXGestureActionBlock)block
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

- (UIImage *)byx_screenshot {
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
