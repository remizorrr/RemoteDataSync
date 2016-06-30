//
//  RDSToastNotification.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import "RDSToastNotification.h"

@implementation RDSToastNotification

+ (void) showToastInViewController:(UIViewController*)viewController message:(NSString*)message backgroundColor:(UIColor*)color duration:(NSTimeInterval)duration tapBlock:(void(^)())tapBlock {
    CGRect frame = CGRectMake(0, -50.0, CGRectGetWidth(viewController.navigationController.view.frame), 50.0);
    CGRect visibleFrame = frame;
    visibleFrame.origin.y = viewController.navigationController?CGRectGetMaxY(viewController.navigationController.navigationBar.frame):0;
    UILabel* toastView = [[UILabel alloc] initWithFrame:frame];
    toastView.text = message;
    toastView.textColor = [UIColor whiteColor];
    toastView.textAlignment = NSTextAlignmentCenter;
    [viewController.view addSubview:toastView];
    toastView.backgroundColor = color;
    [UIView animateWithDuration:0.4 animations:^{
        toastView.frame = visibleFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:duration options:0
                         animations:^{
                             toastView.frame = frame;
                         } completion:^(BOOL finished) {
                             [toastView removeFromSuperview];
                         }];
    }];
}

@end
