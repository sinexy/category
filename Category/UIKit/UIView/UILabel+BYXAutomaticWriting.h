//
//  UILabel+BYXAutomaticWriting.h
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/23.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BYXLabelBlinkMode) {
    BYXLabelBlinkModeNone,
    BYXLabelBlinkModeUntilFinish,
    BYXLabelBlinkModeUntilFinishKeeping,
    BYXLabelBlinkModeWhenFinish,
    BYXLabelBlinkModeWhenFinishShowing,
    BYXLabelBlinkModeAlways
};

@interface UILabel (BYXAutomaticWriting)

@property (nonatomic, strong) NSOperationQueue *byx_automaticWritingOperationQueue;
@property (nonatomic, assign) UIEdgeInsets byx_edgeInsets;

- (void)byx_setTextWithAutomaticWritingAnimation:(NSString *)text;

- (void)byx_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration;

- (void)byx_setText:(NSString *)text automicWritingAnimationWithBlinkingMode:(BYXLabelBlinkMode)blinkingMode;

- (void)byx_setText:(NSString *)text automicWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(BYXLabelBlinkMode)blinkingMode;

- (void)byx_setText:(NSString *)text automaticWritingAnimationWithDUration:(NSTimeInterval)duration blinkingMode:(BYXLabelBlinkMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter;

- (void)byx_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(BYXLabelBlinkMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter completion:(void(^)(void))completion;


@end


