//
//  EBDAppDelegateManager.m
//  EBusDriver
//
//  Created by Andy on 15-6-4.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "SHAppDelegateManager.h"
#import "UIImage+Mycategory.h"
#import "LPTabBarController.h"
#import "LPADLaunchController.h"
#import "LPNavigationController.h"

@interface SHAppDelegateManager ()<UINavigationControllerDelegate,UITabBarControllerDelegate>
{
    UIWindow                * _window;
    __block UINavigationController  * _navController;
    LPTabBarController      *_tabController;
}
@end

@implementation SHAppDelegateManager


+ (SHAppDelegateManager *)sharedSHAppDelegateManager
{
    static SHAppDelegateManager * appDelegatemanager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDelegatemanager = [[SHAppDelegateManager alloc] init];
    });
    return appDelegatemanager;
}


- (void)loginEvent
{
    UIViewController   *loginController = [UIViewController new];
    [_navController pushViewController:loginController animated:YES];
}

- (id)init
{
    if (self = [super init])
    {
        _delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

//        // 自定义UIBarButtonItem返回按钮背景图片
//        UIImage *backButton = [[UIImage imageNamed:@"BackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.0, 0, 5.0)];
//        UIImage *backButtonHighlighted = [[UIImage imageNamed:@"BackButtonHighlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.0, 0, 5.0)];
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonHighlighted forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // 自定义UIBarButtonItem返回按钮标题文字位置
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(10.0, 1000) forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

- (void)dealloc
{

}


- (UIWindow*)getAppWindow
{
    
    return _window;
}

- (void)installRootViewControllerIntoWindow:(UIWindow *)window
{
    _window = window;
    [self initTabController];

}


- (void)initTabController
{
    _tabController = [[LPTabBarController alloc] init];
    if (_window.rootViewController) {
        [_window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_window.rootViewController removeFromParentViewController];
    }
    _window.rootViewController = _tabController;
    [_window makeKeyAndVisible];
}

- (void)addADLaunchController
{
    UIViewController *rootViewController = _window.rootViewController;
    LPADLaunchController *launchController = [[LPADLaunchController alloc]init];
    [rootViewController addChildViewController:launchController];
    launchController.view.frame = rootViewController.view.frame;
    [rootViewController.view addSubview:launchController.view];
}


- (LPNavigationController*)navigationWithRootController:(UIViewController*)controller
{
    LPNavigationController *navController = [[LPNavigationController alloc]initWithRootViewController:controller];
//    navController.delegate = self;
    if ([navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [navController.navigationBar setBackgroundImage:[[UIImage imageWithColor:SHColor_navbkg size:CGSizeMake(ScreenWidth, 3)] stretchableImageWithLeftCapWidth:100.f topCapHeight:1] forBarMetrics:UIBarMetricsDefault];
    }
    navController.navigationBar.barTintColor = SHColor_navbkg;
    navController.navigationBar.shadowImage = [UIImage new];

    //设置字体
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [UIColor whiteColor]];
    [shadow setShadowOffset: CGSizeMake(0.5f, 0.0f)];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:
     @{ NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:18.f],
        NSShadowAttributeName: shadow}];
    
    return navController;
}


- (void)pushViewController:(UIViewController*)controller animated:(BOOL)animated
{
//    controller.hidesBottomBarWhenPushed = YES;
//    [[self getCurrentNavigationController] pushViewController:controller animated:YES];
    
    
    
     NSString    *userID = [self getUserID];
    if (userID && ![userID isEqualToString:@""]) {
        
        controller.hidesBottomBarWhenPushed = YES;
        [[self getCurrentNavigationController] pushViewController:controller animated:YES];

    }else
    {
//        EBLoginViewController   *loginController = [EBLoginViewController new];
//        loginController.hidesBottomBarWhenPushed = YES;
//        [[self getCurrentNavigationController]  pushViewController:loginController animated:animated];
    }
     
}


- (void)setCurrentNavigationController:(NSInteger)selectedIndex
{
    [_tabController setSelectedIndex:selectedIndex];
    //    UINavigationController  *nav = (UINavigationController*)_tabController.viewControllers[selectedIndex];
    //    [nav popToRootViewControllerAnimated:YES];
}

- (void)showMessage:(NSString*)message
{
    //[MBProgressHUD showSuccess:message toView:[self getCurrentNavigationController].view];
}


- (UINavigationController*)getCurrentNavigationController
{
    UINavigationController *navController = nil;
    if (_tabController) {
        navController = (UINavigationController*)_tabController.viewControllers[_tabController.selectedIndex];
    }else
        navController = (UINavigationController*)_window.rootViewController;
        
    return navController;
}

- (NSString*)getUserID
{
    NSString    *userID = nil;
    if ([[NSUserDefaults standardUserDefaults] stringForKey:kUserUID] ) {
        userID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserUID];
    }
    return userID;
}


- (void)showLoginViewController
{
//    EBLoginViewController   *loginController = [EBLoginViewController new];
//    loginController.hidesBottomBarWhenPushed = YES;
//    [[self getCurrentNavigationController]  pushViewController:loginController animated:YES];
}

- (UIViewController*)getRootControllerAtIndex:(NSUInteger)index
{
    UINavigationController *navController = (UINavigationController*)_tabController.viewControllers[index];
    return [navController viewControllers][0];
}

///**
// * 取当前mHadleHelper
// */
//- (BBRBleHelper*)getBleHelper
//{
//    BBHomeViewController *homeVC = (BBHomeViewController*)[self getRootControllerAtIndex:0];
//    return [homeVC getBBRBleHelper];
//}

- (UINavigationController*)getOneNavigationController:(UIViewController*)controller{
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [navController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [navController.navigationBar setBackgroundImage:[[UIImage imageWithColor:SHColor_navbkg size:CGSizeMake(ScreenWidth, 3)] stretchableImageWithLeftCapWidth:100.f topCapHeight:1] forBarMetrics:UIBarMetricsDefault];
    //设置字体
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [UIColor whiteColor]];
    [shadow setShadowOffset: CGSizeMake(0.5f, 0.0f)];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:
     @{ NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:18],
        NSShadowAttributeName: shadow}];
    return navController;
}


#pragma mark
#pragma mark navigation Controller
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /*
    if ( [viewController isKindOfClass:[BBPersonalProfileViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:animated];
    } else if ( [navigationController isNavigationBarHidden] ) {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
     */
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController  *nav = (UINavigationController*)viewController;
//        if ([nav.visibleViewController isKindOfClass:[BBMIneViewController class]]/*||/[nav.visibleViewController isKindOfClass:[EBDMineViewController class]]*/) {
//            NSString    *userID = [self getUserID];
//            if (!userID || [userID isEqualToString:@""]) {
//                EBLoginViewController   *loginController = [EBLoginViewController new];
//                loginController.hidesBottomBarWhenPushed = YES;
//                loginController.isRootToLogin = YES;
//                [[self getCurrentNavigationController]  pushViewController:loginController animated:YES];
//            }
//        }
    }
}

@end

