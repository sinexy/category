//
//  UIView+BYXToast.m
//  CategoryDemo
//
//  Created by yunxin bai on 2018/10/22.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIView+BYXToast.h"
#import <objc/runtime.h>
// display duration
static const NSTimeInterval kBYXToastDefaultDuration  = 3.f;

// general appearance
static const CGFloat kBYXToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat kBYXToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat kBYXToastHorizontalPadding   = 10.f;
static const CGFloat kBYXToastVerticalPadding     = 10.f;
static const CGFloat kBYXToastCornerRadius        = 10.f;
static const CGFloat kBYXToastOpacity             = 0.8;
static const CGFloat kBYXToastFontSize            = 16.f;
static const CGFloat kBYXToastMaxTitleLines       = 0;
static const CGFloat kBYXToastMaxMessageLines     = 0;
static const NSTimeInterval kBYXToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat kBYXToastShadowOpacity       = 0.8;
static const CGFloat kBYXToastShadowRadius        = 6.f;
static const CGSize  kBYXToastShadowOffset        = { 4.f, 4.f };
static const BOOL    kBYXToastDisplayShadow       = YES;

// image view size
static const CGFloat kBYXToastImageViewWidth      = 80.f;
static const CGFloat kBYXToastImageViewHeight     = 80.f;

// activity
static const CGFloat kBYXToastActivityWidth       = 100.f;
static const CGFloat kBYXToastActivityHeight      = 100.f;
static const NSString * kBYXToastActivityDefaultPosition = @"kcenter";

// interaction
static const BOOL kBYXToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * kBYXToastTimerKey         = @"kBYXToastTimerKey";
static const NSString * kBYXToastActivityViewKey  = @"kBYXToastActivityViewKey";
static const NSString * kBYXToastTapCallbackKey   = @"kBYXToastTapCallbackKey";
@implementation UIView (BYXToast)

- (void)byx_makeToast:(NSString *)message {
    [self byx_makeToast:message duration:kBYXToastDefaultDuration postion:BYXToastPositionCenter];
}

- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position {
    UIView *toast = [self byx_viewForMessage:message title:nil image:nil];
    [self byx_showToast:toast duration:duration position:position];
    
}

- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position title:(NSString *)title {
    UIView *toast = [self byx_viewForMessage:message title:title image:nil];
    [self byx_showToast:toast duration:duration position:position];
}

- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position image:(UIImage *)image {
    UIView *toast = [self byx_viewForMessage:message title:nil image:image];
    [self byx_showToast:toast duration:duration position:position];
}

- (void)byx_makeToast:(NSString *)message duration:(NSTimeInterval)duration postion:(BYXToastPosition)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self byx_viewForMessage:message title:title image:image];
    [self byx_showToast:toast duration:duration position:position];
}



- (void)byx_showToast:(UIView *)toast {
    [self byx_showToast:toast duration:kBYXToastDefaultDuration position:BYXToastPositionCenter];
}

- (void)byx_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(BYXToastPosition)position {
    [self byx_showToast:toast duration:duration position:position tapCallback:nil];
}

- (void)byx_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(BYXToastPosition)position tapCallback:(void (^)(void))tapCallback {
    toast.center = [self byx_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.f;
    
    if (kBYXToastHidesOnTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(byx_handleToastTapped:)];
        [toast addGestureRecognizer:tap];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    [self addSubview:toast];
    
    [UIView animateWithDuration:kBYXToastFadeDuration delay:0.f options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
        toast.alpha = 1.f;
    } completion:^(BOOL finished) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(byx_toastTimerDidFinish:) userInfo:toast repeats:NO];
        objc_setAssociatedObject(toast, &kBYXToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(toast, &kBYXToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (void)byx_hideToast:(UIView *)toast {
    [UIView animateWithDuration:kBYXToastFadeDuration delay:0.f options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        toast.alpha = 0.f;
    } completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

- (void)byx_toastTimerDidFinish:(NSTimer *)timer {
    [self byx_hideToast:timer.userInfo];
}

- (void)byx_handleToastTapped:(UITapGestureRecognizer *)tap {
    NSTimer *timer = objc_getAssociatedObject(self, &kBYXToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &kBYXToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self byx_hideToast:tap.view];
}

- (void)byx_makeToastActivity {
    [self byx_makeToastActivity:BYXToastPositionCenter];
}

- (void)byx_makeToastActivity:(BYXToastPosition)position {
    UIView *existingActivityView = objc_getAssociatedObject(self, &kBYXToastActivityViewKey);
    if (existingActivityView) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kBYXToastActivityWidth, kBYXToastActivityHeight)];
    activityView.center = [self byx_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kBYXToastOpacity];
    activityView.alpha = 0.f;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = kBYXToastCornerRadius;
    
    if (kBYXToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = kBYXToastShadowOpacity;
        activityView.layer.shadowRadius = kBYXToastShadowRadius;
        activityView.layer.shadowOffset = kBYXToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    objc_setAssociatedObject (self, &kBYXToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:kBYXToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)byx_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &kBYXToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:kBYXToastFadeDuration
                              delay:0.f
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &kBYXToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

- (CGPoint)byx_centerPointForPosition:(BYXToastPosition)position withToast:(UIView *)toast {
    if (position == BYXToastPositionTop) {
        return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + kBYXToastVerticalPadding);
    }else if (position == BYXToastPositionCenter) {
        return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    }else {
        return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - kBYXToastVerticalPadding);
    }
}

- (CGSize)byx_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)byx_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    if (message == nil && title == nil && image == nil) return nil;
    
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
                                    );
    wrapperView.layer.cornerRadius = kBYXToastCornerRadius;
    
    if (kBYXToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = kBYXToastShadowOpacity;
        wrapperView.layer.shadowRadius = kBYXToastShadowRadius;
        wrapperView.layer.shadowOffset = kBYXToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kBYXToastOpacity];
    
    if (image) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(kBYXToastHorizontalPadding, kBYXToastVerticalPadding, kBYXToastImageViewWidth, kBYXToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    if (imageView) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = kBYXToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.f;
    }
    
    if (title) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = kBYXToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:kBYXToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.f;
        titleLabel.text = title;
        
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width*kBYXToastMaxWidth)-imageWidth, self.bounds.size.height*kBYXToastMaxHeight);
        CGSize expectedSizeTitle = [self byx_sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.f, 0.f, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = kBYXToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:kBYXToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.f;
        messageLabel.text = message;
        
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * kBYXToastMaxWidth) - imageWidth, self.bounds.size.height * kBYXToastMaxHeight);
        CGSize expectedSizeMessage = [self byx_sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.f, 0.f, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    CGFloat titleWidth,titleHeight, titleTop, titleLeft;
    
    if (titleLabel) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = kBYXToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + kBYXToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.f;
    }
    
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + kBYXToastHorizontalPadding;
        messageTop = titleTop + titleHeight + kBYXToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (kBYXToastHorizontalPadding * 2)), (longerLeft + longerWidth + kBYXToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + kBYXToastVerticalPadding), (imageHeight + (kBYXToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end
