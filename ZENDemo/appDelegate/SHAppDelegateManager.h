//
//  EBDAppDelegateManager.h
//  EBusDriver
//
//  Created by Andy on 15-6-4.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class LPNavigationController;
@interface SHAppDelegateManager : NSObject
@property (assign,nonatomic) AppDelegate         *delegate;



+ (SHAppDelegateManager *)sharedSHAppDelegateManager;

/**
 * 主视图初始化
 */
- (void)installRootViewControllerIntoWindow:(UIWindow *)window;

- (LPNavigationController*)navigationWithRootController:(UIViewController*)controller;

- (void)initTabController;

/**
 * 视图压栈操作，此处处理登录逻辑
 * 与系统 pushViewController : animated:用法一致
 */
- (void)pushViewController:(UIViewController*)controller animated:(BOOL)animated;

/**
 *设置
 */
- (void)setCurrentNavigationController:(NSInteger)selectedIndex;


- (UINavigationController*)getCurrentNavigationController;

/**
 *显示消息
 */
- (void)showMessage:(NSString*)message;


/**
 * 取当前用户ID,用于判断是否登录
 * @return 已登录返回用户ID,未登录返回nil
 */
- (NSString*)getUserID;

- (void)showLoginViewController;


- (UIViewController*)getRootControllerAtIndex:(NSUInteger)index;

- (void)initLoginView;

///**
// * 取当前mHadleHelper
// */
//- (BBRBleHelper*)getBleHelper;

- (UINavigationController*)getOneNavigationController:(UIViewController*)controller;
@end
