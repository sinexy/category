//
//  UILabel+BYXAttributeText.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/23.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BYXAttributeName) {
    BYXAttributeNameNone,
    BYXAttributeNameUnderline,
    BYXAttributeNameStrikethrough,
};

@interface UILabel (BYXAttributeText)

- (void)byx_appendText:(NSString *)text styles:(BYXAttributeName)style;
- (void)byx_appendText:(NSString *)text color:(UIColor *)color;
- (void)byx_appendText:(NSString *)text font:(UIFont *)font;

- (void)byx_appendText:(NSString *)text tapEvent:(void(^)(void))tapEvent;
- (void)byx_appendText:(NSString *)text styles:(BYXAttributeName)style tapEvent:(void(^)(void))tapEvent;
- (void)byx_appendText:(NSString *)text color:(UIColor *)color tapEvent:(void(^)(void))tapEvent;
- (void)byx_appendText:(NSString *)text font:(UIFont *)font tapEvent:(void(^)(void))tapEvent;

- (void)byx_appendText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
- (void)byx_appendText:(NSString *)text color:(UIColor *)color styles:(BYXAttributeName)style;
- (void)byx_appendText:(NSString *)text font:(UIFont *)font styles:(BYXAttributeName)style;


- (void)byx_appendText:(NSString *)text color:(UIColor *)color font:(UIFont *)font styles:(BYXAttributeName)style tapEvent:(void(^)(void))tapEvent;

@end

