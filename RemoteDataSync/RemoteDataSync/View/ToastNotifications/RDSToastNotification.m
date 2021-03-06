//
//  RDSToastNotification.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "RDSToastNotification.h"

@implementation RDSToastNotification

+ (void) showToastInViewController:(UIViewController*)viewController message:(NSString*)message backgroundColor:(UIColor*)color duration:(NSTimeInterval)duration tapBlock:(void(^)())tapBlock {
    static BOOL _toastVisible = NO;
    if (_toastVisible) {
        return;
    }
    
    _toastVisible = YES;
    
    static UIWindow* window = nil;

    CGFloat barHeight = 30.0;
    CGRect frame = CGRectMake(0, CGRectGetMaxY(viewController.navigationController.navigationBar.frame) - barHeight, CGRectGetWidth(viewController.navigationController.view.frame), barHeight);
    if (viewController.navigationController.navigationBar.hidden || CGColorGetAlpha(viewController.navigationController.navigationBar.backgroundColor.CGColor) <= 0.0) {
        frame.origin.y = -barHeight;
    }
    CGRect visibleFrame = frame;
    visibleFrame.origin.y = viewController.navigationController?CGRectGetMaxY(viewController.navigationController.navigationBar.frame):0;
    if (viewController.navigationController.navigationBar.hidden || CGColorGetAlpha(viewController.navigationController.navigationBar.backgroundColor.CGColor) <= 0.0) {
        visibleFrame.origin.y = 0;
    }
    UILabel* toastView = [[UILabel alloc] initWithFrame:frame];
    toastView.text = message;
    toastView.textColor = [UIColor whiteColor];
    toastView.textAlignment = NSTextAlignmentCenter;
    toastView.backgroundColor = color;
    toastView.alpha = 0.0;
    if (viewController.navigationController.navigationBar.hidden || CGColorGetAlpha(viewController.navigationController.navigationBar.backgroundColor.CGColor) <= 0.0) {
        window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, viewController.view.window.frame.size.width, barHeight)];
        window.windowLevel = UIWindowLevelStatusBar;
        [window makeKeyAndVisible];
        [window addSubview:toastView];
    } else {
        [viewController.navigationController.navigationBar.superview insertSubview:toastView
                                                                      belowSubview:viewController.navigationController.navigationBar];
    }
    NSLog(@"Show Toast");
    [UIView animateWithDuration:0.4 animations:^{
        NSLog(@"Hiide Toast");
        toastView.frame = visibleFrame;
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        NSLog(@"Toast Hidden");
        [UIView animateWithDuration:0.4 delay:duration options:0
                         animations:^{
                             toastView.frame = frame;
                             toastView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [toastView removeFromSuperview];
                             window = nil;
                             _toastVisible = NO;
                         }];
    }];
}

@end
