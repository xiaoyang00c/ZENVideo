//
//  FFLoadingView.h
//  FFLoadingView
//
//  Created by Andy on 2017/6/12.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFLoadingView : UIView

/**
 *  回调block   callback block
 */
typedef void (^FFLoadingCompleteBlock) ();


@property (nonatomic,copy) NSString *tipsText;

/**
 *  线条宽度
 */
@property (nonatomic,assign)CGFloat lineWidth;

/**
 *  线条颜色
 */
@property (nonatomic,copy  )UIColor *strokeColor;

/**
 *  开始 start
 */
- (void)startLoading;

/**
 *  结束，视图会被移除   end, view will be removed
 */
- (void)endLoading;

/**
 *  以成功结束动画    stop animation with a success
 *
 *  @param block 回调（callback）
 */
- (void)finishSuccess:(FFLoadingCompleteBlock)block;

/**
 *  以失败结束动画    stop animation with a failure
 *
 *  @param block 回调（callback）
 */
- (void)finishFailure:(FFLoadingCompleteBlock)block;

/**
 *  以tips结束动画
 *
 *  @param block 回调（callback）
 */
- (void)finishCommon:(FFLoadingCompleteBlock)block;
@end
