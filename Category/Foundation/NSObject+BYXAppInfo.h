//
//  NSObject+BYXAppInfo.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/30.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (BYXAppInfo)

- (NSString *)byx_version;
- (NSInteger)byx_build;
- (NSString *)byx_identifier;
- (NSString *)byx_currentLanguage;
- (NSString *)byx_deviceModel;

@end

