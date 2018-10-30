//
//  NSObject+BYXAppInfo.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/30.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "NSObject+BYXAppInfo.h"
#import <sys/utsname.h>

@implementation NSObject (BYXAppInfo)

- (NSString *)byx_version {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

- (NSInteger)byx_build{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [appBuild integerValue];
}

- (NSString *)byx_identifier{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}

- (NSString *)byx_currentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages firstObject];
    return [NSString stringWithString:currentLanguage];
}

- (NSString *)byx_deviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return [NSString stringWithString:deviceString];
}

@end
