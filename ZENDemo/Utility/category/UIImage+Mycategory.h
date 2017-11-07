//
//  UIImage+Mycategory.h
//  GoddessClock
//
//  Created by wubing on 14-9-13.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mycategory)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)normalizedImage;

- (UIImage *)colorizeImageWithColor:(UIColor *)color;

+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (UIImage *)compressSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end
