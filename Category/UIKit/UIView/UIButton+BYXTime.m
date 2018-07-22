//
//  UIButton+YXCategory.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/6/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIButton+BYXTime.h"
#import <objc/runtime.h>

static const char kButtonImageViewStyleKey;
static const char kButtonImageSizeKey;
static const char kButtomImageSpaceKey;

const static char *kTimerKey = "kTimerKey";
const static char *kStartTime = "kStartTime";
const static char *kUnit = "kUnit";
const static char *kStartTitleColor = "kStartTitleColor";
const static char *kEndTitle = "kEndTitle";
const static char *kEndColor = "kEndColor";

@implementation UIButton (BYXTime)

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

- (void)yx_setStartTime:(NSInteger)timeout unit:(NSString *)unitTitle startTitleColor:(UIColor *)startColor endTitle:(NSString *)endTitle endColor:(UIColor *)endColor{
    objc_setAssociatedObject(self, kStartTime, @(timeout), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, kUnit, unitTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kStartTitleColor, startColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kEndColor, endColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kEndTitle, endTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupEndUI];
    
}

-(void)yx_startTime{
    
    NSInteger startTime = [objc_getAssociatedObject(self, kStartTime) integerValue]; //倒计时时间
    __block NSInteger timeOut = startTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    objc_setAssociatedObject(self, kTimerKey, _timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupEndUI];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeOut % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setupStartUI:strTime];
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)yx_cancelTime
{
    dispatch_source_t _timer = objc_getAssociatedObject(self, kTimerKey);
    if (_timer) {
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupEndUI];
        });
    }
}

- (void)setupStartUI:(NSString *)strTime
{
    UIColor *startColor = objc_getAssociatedObject(self, kStartTitleColor);
    NSString *unitTitle = objc_getAssociatedObject(self, kUnit);
    
    [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,unitTitle] forState:UIControlStateNormal];
    [self setTitleColor:startColor forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
}

- (void)setupEndUI
{
    UIColor *endColor = objc_getAssociatedObject(self, kEndColor);
    NSString *endTitle = objc_getAssociatedObject(self, kEndTitle);
    
    [self setTitle:endTitle forState:UIControlStateNormal];
    [self setTitleColor:endColor forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

@end
