//
//  RefreshButton.h
//  BuFu
//
//  Created by Andy on 15/5/27.
//  Copyright (c) 2015年 Huifeng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *playImage, *stopImage;

@interface RefreshButton : UIButton<CAAnimationDelegate>{
    
    CGFloat _r;
    CGFloat _g;
    CGFloat _b;
    CGFloat _a;
    
    CGFloat _progress;
    
    CGRect _outerCircleRect;
    CGRect _innerCircleRect;
    
    UIImage *image;
    UIImageView *loadingView;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithFrame:(CGRect)frame;
- (void)setDurImageWith:(NSString *)imageNaem;
- (void)startSpin;
- (void)stopSpin;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)newProgress;
- (void)setColourR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

@end











