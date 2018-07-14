//
//  UILabel+Category.m
//  YaoQianGuan
//
//  Created by yunxin bai on 2018/6/27.
//  Copyright © 2018年 NeverMore. All rights reserved.
//

#import "UILabel+YXCategory.h"

@implementation UILabel (YXCategory)

- (NSAttributedString *)yx_setAttributedString:(NSString *)string withLineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    self.attributedText = attributedString;
    return attributedString;
    
}

@end
