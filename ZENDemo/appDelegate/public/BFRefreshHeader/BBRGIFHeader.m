//
//  BBRGIFHeader.m
//  BBRobot
//
//  Created by Andy on 2017/9/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "BBRGIFHeader.h"

@implementation BBRGIFHeader

- (void)prepare {

    [super prepare];

    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%ld",i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages duration:idleImages.count*0.2 forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%ld", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:refreshingImages.count*0.2 forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:refreshingImages.count*0.2 forState:MJRefreshStateRefreshing];

    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
    
}

@end
