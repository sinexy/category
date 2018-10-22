//
//  UIView+BYXToast.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/22.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, BYXToastPosition) {
    BYXToastPositionTop = 1,
    BYXToastPositionCenter,
    BYXToastPositionBottom
};

@interface UIView (BYXToast)

- (void)byx_makeToast:(NSString *)message;
- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position;
- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position image:(UIImage *)image;
- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position title:(NSString *)title;
- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position title:(NSString *)title image:(UIImage *)image;


- (void)byx_makeToastActivity;
- (void)byx_makeToastActivity:(BYXToastPosition)position;
- (void)byx_hideToastActivity;


- (void)byx_showToast:(UIView *)toast;
- (void)byx_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(BYXToastPosition)position;
- (void)byx_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(BYXToastPosition)position tapCallback:(void(^)(void))tapCallback;

@end

