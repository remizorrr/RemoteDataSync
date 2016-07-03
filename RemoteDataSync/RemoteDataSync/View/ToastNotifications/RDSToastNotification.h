//
//  RDSToastNotification.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDSToastNotification : NSObject

+ (void) showToastInViewController:(UIViewController*)viewController message:(NSString*)message backgroundColor:(UIColor*)color duration:(NSTimeInterval)duration tapBlock:(void(^)())tapBlock;

@end
