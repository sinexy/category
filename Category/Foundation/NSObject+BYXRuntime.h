//
//  NSObject+BYXRuntime.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/30.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BYXRuntime)

/**
 * 交换方法
 * @param originalMethod 被替换的方法
 * @param newMethod 替换的新方法
 */
+ (void)byx_swizzleMehtod:(SEL)originalMethod withMethod:(SEL)newMethod;

/**
 * 为一个类新增方法
 * @param newMethod 新方法
 * @param klass 需要添加的类
 */
+ (void)byx_appendMethod:(SEL)newMethod fromClass:(Class)klass;

/**
 * 替换该类方法的实现
 * @param method 被替换的方法
 * @param klass 需要替换的类
 */
+ (void)byx_replaceMthod:(SEL)method fromClass:(Class *)klass;

/**
 * 判断该类及其子类是否实现某个方法
 * @param selector 方法
 * @param stopClass 类
 */
- (BOOL)byx_respondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 * 判断其父类是否实现某个方法
 * @param selector 方法
 */
- (BOOL)byx_superRespondsToSelector:(SEL)selector;

/**
 * 判断其父类是否实现某个方法
 * @param selector 方法
 * @param stopClass 截至这层类
 */
- (BOOL)byx_superRespondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 * 判断该类及其子类是否实现某个方法
 * @param selector 方法
 * @param stopClass 截至这层类
 */
+ (BOOL)byx_instancesRespondToSelector:(SEL)selector untilClass:(Class)stopClass;

@end


