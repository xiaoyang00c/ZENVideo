//
//  UIView+firstController.m
//  BBRobot
//
//  Created by Andy on 2017/9/12.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "UIView+firstController.h"

@implementation UIView (firstController)

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
