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

@interface UIButton (YXCategory)

/**
 设置 按钮 图片所在的位置
 
 @param style   图片位置类型（上、左、下、右）
 @param size    图片的大小
 @param space 图片跟文字间的间距
 */
- (void)yx_setImageViewStyle:(ImageViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;

@end
