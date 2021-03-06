//
//  UILabel+Category.h
//  YaoQianGuan
//
//  Created by yunxin bai on 2018/6/27.
//  Copyright © 2018年 NeverMore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BYXPadding)

/**
 * 增加 label 行间距
 * 实质是用 attribute
 */
- (NSAttributedString *)byx_setAttributedString:(NSString *)string withLineSpace:(CGFloat)lineSpace;

@end
