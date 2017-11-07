//
//  BFNormalHeader.m
//  BuFu
//
//  Created by Andy on 15/9/29.
//  Copyright (c) 2015年 Huifeng Technology Co.,Ltd. All rights reserved.
//

#import "RefreshButton.h"
#import "BFNormalHeader.h"

@interface BFNormalHeader()

@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) RefreshButton *activityView;

@end

@implementation BFNormalHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头
    CGFloat arrowX = self.mj_w * 0.5;
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
    // 指示器
    self.activityView.center = self.arrowImage.center;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
        {
            self.activityView.alpha = 0.0;
            self.arrowImage.alpha = 1.0;
            self.activityView.alpha = 1.0;
            [self.activityView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.activityView stopSpin];
        }
            break;
        case MJRefreshStatePulling:
        {}
            break;
        case MJRefreshStateRefreshing:
        {
            [self.activityView setImage:[UIImage imageNamed:@"bf_refresh_arrow"] forState:UIControlStateNormal];
            [self.activityView startSpin];
            self.arrowImage.alpha = 0.0;
        }
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


- (RefreshButton *)activityView
{
    if (!_activityView) {
        RefreshButton *activityView = [[RefreshButton alloc] init];
        activityView.frame = CGRectMake(0, 0, self.arrowImage.bounds.size.height, self.arrowImage.bounds.size.height);
        activityView.userInteractionEnabled = NO;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bf_refresh_arrow"]];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

@end









