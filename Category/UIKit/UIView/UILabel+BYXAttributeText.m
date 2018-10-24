//
//  UILabel+BYXAttributeText.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/23.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UILabel+BYXAttributeText.h"



@implementation UILabel (BYXAttributeText)

- (void)byx_appendText:(NSString *)text font:(UIFont *)font {
    [self byx_appendText:text font:font styles:BYXAttributeNameNone];
}

- (void)byx_appendText:(NSString *)text color:(UIColor *)color {
    [self byx_appendText:text color:color styles:BYXAttributeNameNone];
}

- (void)byx_appendText:(NSString *)text styles:(BYXAttributeName)style {
    [self byx_appendText:text styles:style tapEvent:nil];
}

- (void)byx_appendText:(NSString *)text tapEvent:(void (^)(void))tapEvent {
    [self byx_appendText:text styles:BYXAttributeNameNone tapEvent:tapEvent];
}

- (void)byx_appendText:(NSString *)text font:(UIFont *)font styles:(BYXAttributeName)style {
    [self byx_appendText:text color:nil font:font styles:style tapEvent:nil];
}

- (void)byx_appendText:(NSString *)text styles:(BYXAttributeName)style tapEvent:(void (^)(void))tapEvent {
    [self byx_appendText:text color:nil font:nil styles:style tapEvent:tapEvent];
}

- (void)byx_appendText:(NSString *)text color:(UIColor *)color font:(UIFont *)font {
    [self byx_appendText:text color:color font:font styles:BYXAttributeNameNone tapEvent:nil];
}

- (void)byx_appendText:(NSString *)text font:(UIFont *)font tapEvent:(void (^)(void))tapEvent {
    [self byx_appendText:text color:nil font:font styles:BYXAttributeNameNone tapEvent:tapEvent];
}

- (void)byx_appendText:(NSString *)text color:(UIColor *)color tapEvent:(void (^)(void))tapEvent {
    [self byx_appendText:text color:color font:nil styles:BYXAttributeNameNone tapEvent:tapEvent];
}

- (void)byx_appendText:(NSString *)text color:(UIColor *)color styles:(BYXAttributeName)style {
    [self byx_appendText:text color:color font:nil styles:style tapEvent:nil];
}

- (void)byx_appendText:(NSString *)text color:(UIColor *)color font:(UIFont *)font styles:(BYXAttributeName)style tapEvent:(void (^)(void))tapEvent {
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    NSAttributedString *oldString;
    
    UIColor *defaultColor = self.textColor;
    
    if (self.attributedText.length) {
        oldString = [self.attributedText mutableCopy];
    } else if (self.text.length) {
        oldString = [[NSAttributedString alloc] initWithString:self.text];
    } else {
        oldString = [[NSAttributedString alloc] initWithString:@""];
    }
    NSRange range = NSMakeRange(0, oldString.length);
    NSDictionary *dic = [oldString attributesAtIndex:0 effectiveRange:&range];
    
    [attributedString appendAttributedString:oldString];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:text]];

    if (dic) {
        [attributedString addAttributes:dic range:range];
    }
    
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(oldString.length, text.length)];
    }
    
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(oldString.length, text.length)];
    }
    
    if (style == BYXAttributeNameUnderline) {
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(oldString.length, text.length)];
        [attributedString addAttribute:NSStrikethroughColorAttributeName value:color?:defaultColor range:NSMakeRange(oldString.length, text.length)];
    }else if (style == BYXAttributeNameStrikethrough) {
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:NSMakeRange(oldString.length, text.length)];
        [attributedString addAttribute:NSUnderlineColorAttributeName value:color?:defaultColor range:NSMakeRange(oldString.length, text.length)];
    }
    CGRect rect = [self textRectForBounds:self.frame limitedToNumberOfLines:0];
    NSLog(@"%@", NSStringFromCGRect(rect));
    
    if (tapEvent) {
        self.userInteractionEnabled = YES;
        tapEvent();
    }
    self.text = @"";
    self.attributedText = attributedString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *array = touches.allObjects;
    UITouch *touch = array.firstObject;
    CGPoint point = [touch locationInView:self];
    NSLog(@"%f,%f",point.x, point.y);
}


@end
