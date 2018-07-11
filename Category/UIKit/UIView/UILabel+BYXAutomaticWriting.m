//
//  UILabel+BYXAutomaticWriting.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/23.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UILabel+BYXAutomaticWriting.h"
#import <objc/runtime.h>

NSTimeInterval const kBYXAutomicWritingDefaultDuration = 0.4f;

unichar const kBYXAutomicWritingDefaultCharacter = 124;

static inline void byx_automaticWritingSwizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static char kAutomaticWritingOperationQueueKey;
static char kAutomaticWritingEdgeInsetsKey;

@implementation UILabel (BYXAutomaticWriting)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        byx_automaticWritingSwizzleSelector([self class], @selector(textRectForBounds:limitedToNumberOfLines:), @selector(byx_automaticWritingTextRectForBounds:limitedToNumberOfLines:));
        byx_automaticWritingSwizzleSelector([self class], @selector(drawTextInRect:), @selector(byx_drawAutomicWritingTextInRect:));
    });
}

- (void)byx_drawAutomicWritingTextInRect:(CGRect)rect {
    [self byx_drawAutomicWritingTextInRect:UIEdgeInsetsInsetRect(rect, self.byx_edgeInsets)];
}

- (CGRect)byx_automaticWritingTextRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [self byx_automaticWritingTextRectForBounds:UIEdgeInsetsInsetRect(bounds, self.byx_edgeInsets) limitedToNumberOfLines:numberOfLines];
    return textRect;
}

- (void)setByx_edgeInsets:(UIEdgeInsets)byx_edgeInsets
{
    objc_setAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey, [NSValue valueWithUIEdgeInsets:byx_edgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)byx_edgeInsets
{
    NSValue *edgeInsetsValue = objc_getAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey);
    
    if (edgeInsetsValue) {
        return edgeInsetsValue.UIEdgeInsetsValue;
    }
    
    edgeInsetsValue = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero];
    
    objc_setAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey, edgeInsetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return edgeInsetsValue.UIEdgeInsetsValue;
}

- (void)setByx_automaticWritingOperationQueue:(NSOperationQueue *)byx_automaticWritingOperationQueue
{
    objc_setAssociatedObject(self, &kAutomaticWritingOperationQueueKey, byx_automaticWritingOperationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOperationQueue *)byx_automaticWritingOperationQueue
{
    NSOperationQueue *queue = objc_getAssociatedObject(self, &kAutomaticWritingOperationQueueKey);
    if (queue) {
        return queue;
    }
    queue = NSOperationQueue.new;
    queue.name = @"Automic Writing Operation Queue";
    queue.maxConcurrentOperationCount = 1;
    
    objc_setAssociatedObject(self, &kAutomaticWritingOperationQueueKey, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return queue;
}




- (void)byx_setTextWithAutomaticWritingAnimation:(NSString *)text {
    [self byx_setText:text automicWritingAnimationWithBlinkingMode:BYXLabelBlinkModeNone];
}

- (void)byx_setText:(NSString *)text automicWritingAnimationWithBlinkingMode:(BYXLabelBlinkMode)blinkingMode {
    [self byx_setText:text automicWritingAnimationWithDuration:kBYXAutomicWritingDefaultDuration blinkingMode:blinkingMode];
}

- (void)byx_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration {
    [self byx_setText:text automicWritingAnimationWithDuration:duration blinkingMode:BYXLabelBlinkModeNone];
}

- (void)byx_setText:(NSString *)text automicWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(BYXLabelBlinkMode)blinkingMode {
    [self byx_setText:text automaticWritingAnimationWithDUration:duration blinkingMode:blinkingMode blinkingCharacter:kBYXAutomicWritingDefaultCharacter];
}

- (void)byx_setText:(NSString *)text automaticWritingAnimationWithDUration:(NSTimeInterval)duration blinkingMode:(BYXLabelBlinkMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter {
    [self byx_setText:text automaticWritingAnimationWithDuration:duration blinkingMode:blinkingMode blinkingCharacter:blinkingCharacter completion:nil];
}

- (void)byx_setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(BYXLabelBlinkMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter completion:(void (^)(void))completion {
    self.byx_automaticWritingOperationQueue.suspended = YES;
    self.byx_automaticWritingOperationQueue = nil;
    
    self.text = @"";
    
    NSMutableString *automaticWritingText = NSMutableString.new;
    
    if (text) {
        [automaticWritingText appendString:text];
    }
    
    [self.byx_automaticWritingOperationQueue addOperationWithBlock:^{
       
    }];
}

#pragma mark - private methods
- (void)byx_automicWriting:(NSMutableString *)text duration:(NSTimeInterval)duration mode:(BYXLabelBlinkMode)mode character:(unichar)character completion:(void(^)(void))completion {
    NSOperationQueue *currentQueue = NSOperationQueue.currentQueue;
    if ((text.length || mode >= BYXLabelBlinkModeWhenFinish) && !currentQueue.isSuspended) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (mode != BYXLabelBlinkModeNone) {
                if ([self byx_isLastCharacter:character]) {
                    [self byx_deleteLastCharacter];
                } else if (mode != BYXLabelBlinkModeWhenFinish || !text.length) {
                    [text insertString:[self byx_stringWithCharacter:character] atIndex:0];
                }
            }
            
            if (text.length) {
                [self byx_appendCharacter:[text characterAtIndex:0]];
                [text deleteCharactersInRange:NSMakeRange(0, 1)];
                if ((![self byx_isLastCharacter:character] && mode == BYXLabelBlinkModeWhenFinishShowing) || (!text.length && mode == BYXLabelBlinkModeUntilFinishKeeping)) {
                    [self byx_appendCharacter:character];
                }
            }
            
            if (!currentQueue.isSuspended) {
                [currentQueue addOperationWithBlock:^{
                    [self byx_automicWriting:text duration:duration mode:mode character:character completion:completion];
                }];
            } else if (completion) {
                completion();
            }
        });
    } else if (completion) {
        completion();
    }
}

- (NSString *)byx_stringWithCharacter:(unichar)character {
    return [self byx_stringWithCharacters:@[@(character)]];
}

- (NSString *)byx_stringWithCharacters:(NSArray *)characters {
    NSMutableString *string = NSMutableString.new;
    
    for (NSNumber *character in characters) {
        [string appendFormat:@"%C", character.unsignedShortValue];
    }
    return string.copy;
}

- (void)byx_appendCharacter:(unichar)character {
    [self byx_appendCharacters:@[@(character)]];
}

- (void)byx_appendCharacters:(NSArray *)characters {
    self.text = [self.text stringByAppendingString:[self byx_stringWithCharacters:characters]];
}

- (BOOL)byx_isLastCharacters:(NSArray *)characters {
    if (self.text.length >= characters.count) {
        return [self.text hasSuffix:[self byx_stringWithCharacters:characters]];
    }
    return NO;
}

- (BOOL)byx_isLastCharacter:(unichar)character {
    return [self byx_isLastCharacters:@[@(character)]];
}

- (BOOL)byx_deleteLastCharacters:(NSUInteger)characters {
    if (self.text.length >= characters) {
        self.text = [self.text substringToIndex:self.text.length-characters];
        return YES;
    }
    return NO;
}

- (BOOL)byx_deleteLastCharacter {
    return [self byx_deleteLastCharacters:1];
}
@end
