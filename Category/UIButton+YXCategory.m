//
//  UIButton+YXCategory.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIButton+YXCategory.h"
#import <objc/runtime.h>

static const char kButtonImageViewStyleKey;
static const char kButtonImageSizeKey;
static const char kButtomImageSpaceKey;

@implementation UIButton (YXCategory)

- (void)yx_setImageViewStyle:(ImageViewStyle)style imageSize:(CGSize)size space:(CGFloat)space
{
    objc_setAssociatedObject(self, &kButtonImageViewStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kButtomImageSpaceKey, @(space), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kButtonImageSizeKey, NSStringFromCGSize(size), OBJC_ASSOCIATION_COPY_NONATOMIC);
}


+ (void)load
{
    Method m1 = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method m2 = class_getInstanceMethod([self class], @selector(yx_layoutSubviews));
    method_exchangeImplementations(m1, m2);
}

- (void)yx_layoutSubviews
{
    [self yx_layoutSubviews];
    
    NSNumber *typeNum = objc_getAssociatedObject(self, &kButtonImageViewStyleKey);
    if (typeNum) {
        NSNumber *spaceNum = objc_getAssociatedObject(self, &kButtomImageSpaceKey);
        NSString *imgSizeStr = objc_getAssociatedObject(self, &kButtonImageSizeKey);
        CGSize imgSize = self.currentImage ? CGSizeFromString(imgSizeStr) : CGSizeZero;
        CGSize labelSize = self.currentTitle.length ? [self.currentTitle sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}] : CGSizeZero;
        
        CGFloat space = (labelSize.width && self.currentImage) ? spaceNum.floatValue : 0;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGFloat imgX, imgY, labelX, labelY;
        
        switch (typeNum.integerValue) {
            case ImageViewStyleLeft:
            {
                imgX = (width - imgSize.width - labelSize.width - space)/2.0;
                imgY = (height - imgSize.height)/2.0;
                labelX = imgX + imgSize.width + space;
                labelY = (height - labelSize.height)/2.0;
                self.imageView.contentMode = UIViewContentModeRight;
                break;
            }
            case ImageViewStyleTop:
            {
                imgX = (width - imgSize.width)/2.0;
                imgY = (height - imgSize.height - space - labelSize.height)/2.0;
                labelX = (width - labelSize.width)/2;
                labelY = imgY + imgSize.height + space;
                self.imageView.contentMode = UIViewContentModeBottom;
                break;
            }
            case ImageViewStyleRight:
            {
                labelX = (width - imgSize.width - labelSize.width - space)/2.0;
                labelY = (height - labelSize.height)/2.0;
                imgX = labelX + labelSize.width + space;
                imgY = (height - imgSize.height)/2.0;
                self.imageView.contentMode = UIViewContentModeLeft;
                break;
            }
            case ImageViewStyleBottom:
            {
                labelX = (width - labelSize.width)/2.0;
                labelY = (height - labelSize.height - imgSize.height -space)/2.0;
                imgX = (width - imgSize.width)/2.0;
                imgY = labelY + labelSize.height + space;
                self.imageView.contentMode = UIViewContentModeTop;
                break;
            }
            default:
                break;
        }
        self.imageView.frame = CGRectMake(imgX, imgY, imgSize.width, imgSize.height);
        self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    }
}



@end
