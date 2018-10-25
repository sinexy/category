//
//  UILabel+BYXAttributeText.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/23.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UILabel+BYXAttributeText.h"
#import <objc/runtime.h>

static NSString *kBYXAttributeTextAreaKey = @"kBYXAttributeTextAreaKey";


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
    
    NSMutableAttributedString *attributedString = [self getOriginalAttributeString];
    NSAttributedString *newAttributedString = [self getNewAttributeString:text color:color font:font styles:style];
    [attributedString appendAttributedString:newAttributedString];
    
    if (tapEvent) {
        self.userInteractionEnabled = YES;
    }else {
        tapEvent = ^{
            
        };
    }
    [self setTapRect:text font:font styles:style tapEvent:tapEvent];

    self.attributedText = attributedString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *array = touches.allObjects;
    UITouch *touch = array.firstObject;
    CGPoint point = [touch locationInView:self];
    NSLog(@"%f,%f",point.x, point.y);
    void (^blockName)(void);
    
    
    NSMutableArray *textArrayM = objc_getAssociatedObject(self, &kBYXAttributeTextAreaKey);
    for (NSArray *array in textArrayM) {
        blockName = array[2];
        NSArray *rectArray = array[1];
        for (id r in rectArray) {
            CGRect rect = [r CGRectValue];
            if ((rect.origin.x < point.x && (rect.size.width+rect.origin.x) > point.x) && (rect.origin.y < point.y && (rect.size.height+rect.origin.y) > point.y)) {  // 点在区域内
                NSLog(@"%@",array[0]);
                blockName();
                return;
            }
        }

    }
    
    
}


#pragma mark - private method

- (NSMutableAttributedString *)getOriginalAttributeString {
    NSMutableAttributedString *attributedString;
    if (self.attributedText.length) {
        attributedString = [self.attributedText mutableCopy];
    } else if (self.text.length) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedString = [NSMutableAttributedString new];
    }
    if (attributedString.length == 0) {
        return attributedString;
    }
    NSRange range = NSMakeRange(0, attributedString.length);
    NSDictionary *dic = [attributedString attributesAtIndex:0 effectiveRange:&range];
    if (dic) {
        [attributedString addAttributes:dic range:range];
    }
    return attributedString;
}

- (NSAttributedString *)getNewAttributeString:(NSString *)text color:(UIColor *)color font:(UIFont *)font styles:(BYXAttributeName)style {

    NSMutableDictionary *attributeDiction = [NSMutableDictionary dictionary];
    if (color) {
        [attributeDiction setValue:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attributeDiction setValue:font forKey:NSFontAttributeName];
    }
    if (style == BYXAttributeNameUnderline) {
        [attributeDiction setValue:@(1) forKey:NSStrikethroughStyleAttributeName];
        [attributeDiction setValue:color?:self.textColor forKey:NSStrikethroughColorAttributeName];
    }else if (style == BYXAttributeNameStrikethrough) {
        [attributeDiction setValue:@(1) forKey:NSUnderlineStyleAttributeName];
        [attributeDiction setValue:color?:self.textColor forKey:NSUnderlineColorAttributeName];
    }
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:text attributes:attributeDiction];
    return attributeString;
}

- (void)setTapRect:(NSString *)text font:(UIFont *)font styles:(BYXAttributeName)style tapEvent:(void (^)(void))tapEvent {
    
    NSMutableArray *textArrayM = objc_getAssociatedObject(self, &kBYXAttributeTextAreaKey);
    if (!textArrayM) {
        textArrayM = [NSMutableArray array];
        objc_setAssociatedObject(self, &kBYXAttributeTextAreaKey, textArrayM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSArray *oldRectArray = [textArrayM lastObject][1];
    CGRect lastRect = CGRectZero;
    for (id r in oldRectArray) {
        lastRect = [r CGRectValue];
    }
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font?:self.font} context:nil].size;
    CGFloat x = lastRect.origin.x + lastRect.size.width;
    CGFloat soloWidth = round(textSize.width / text.length);
    NSInteger line = (x + textSize.width) / self.frame.size.width;
    CGFloat width = round(textSize.width);
    CGFloat height = round(textSize.height);
    
    NSMutableArray *rectArrayM = [NSMutableArray array];
    CGRect rect;
    if (line > 0) {

        width = 0;
        while (x + width + soloWidth <= self.frame.size.width) {
            width += soloWidth;
        }
        int i = 0;
        do {
            rect = CGRectMake(x, lastRect.origin.y + i * height, width, height);
            [rectArrayM addObject:@(rect)];
            i++;
            x = 0;
            width = textSize.width - width;
            int currentLine = width / self.frame.size.width;
            if (currentLine > 0) {
                width = 0;
                while (x + width + soloWidth <= self.frame.size.width) {
                    width += soloWidth;
                }
            }
            
        } while (i <= line || width > self.frame.size.width);
        
    }else {
        rect = CGRectMake(x, line*height, width, height);
        [rectArrayM addObject:@(rect)];
    }
    
    [textArrayM addObject:@[text,rectArrayM,tapEvent]];

}

- (void)getLastRect:(NSString *)text {
    
}

@end
