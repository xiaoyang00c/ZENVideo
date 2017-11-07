//
//  LPTabBarController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTabBarController.h"
#import "UITabBarController+AddChildVC.h"
#import "LPNavigationController.h"
#import "UIImage+Mycategory.h"
#import "ZENHomeViewController.h"
#import "ZENMineViewController.h"
#import "ZENCameraViewController.h"


@interface LPTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>

@property (nonatomic,assign) NSUInteger indexFlag;
@end

@implementation LPTabBarController

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    [[tabbarbuttonArray[index] layer] removeAllAnimations];
    
    CABasicAnimation *scaleAnimation1 = [self scaleFrom:1.0
                                                toScale:1.24
                                               durTimes:0.08
                                                    rep:MAXFLOAT];
    scaleAnimation1.beginTime = 0;
    
    
    CABasicAnimation *scaleAnimation2 = [self scaleFrom:1.24
                                                toScale:0.73
                                               durTimes:0.08
                                                    rep:MAXFLOAT];
    scaleAnimation2.beginTime = 0.08;
    
    
    CABasicAnimation *scaleAnimation3 = [self scaleFrom:0.73
                                                toScale:1.0
                                               durTimes:0.08
                                                    rep:MAXFLOAT];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.24;
    
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    
    // 添加动画
    group.animations = [NSArray arrayWithObjects:scaleAnimation1, scaleAnimation2,scaleAnimation3,nil];
    [[tabbarbuttonArray[index] layer] addAnimation:group forKey:@"move-rotate-layer"];
    
    self.indexFlag = index;
    
}

- (CABasicAnimation *)scaleFrom:(CGFloat)fromScale toScale:(CGFloat)toScale durTimes:(float)time rep:(float)repeatTimes
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(fromScale);
    animation.toValue = @(toScale);
    animation.duration = time;
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _indexFlag = selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self configureTabBar];
    
    [self configureChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)configureTabBar
{
//    self.tabBar.shadowImage = [UIImage imageNamed:@"tabbartop-line"];
    [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithRed:0.87 green:0.88 blue:0.90 alpha:0.5] size:CGSizeMake(ScreenWidth, 2)]];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth, 49)]];
    
    // blur效果
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = CGRectMake(0, -1, CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame)+1);
    visualEfView.alpha = 1.0;
    [self.tabBar insertSubview:visualEfView atIndex:0];
    
    [[UITabBarItem appearanceWhenContainedIn:[LPTabBarController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1.0] } forState:UIControlStateNormal];
    
    [[UITabBarItem appearanceWhenContainedIn:[LPTabBarController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"313333"]} forState:UIControlStateSelected];
}

- (void)configureChildViewControllers
{
    [self addHomeController];

    [self addCameraController];
    
    [self addMineController];
    
}

#pragma mark - add childVC

- (void)addHomeController {
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, 0);
    
    [self addChildViewController:[[ZENHomeViewController alloc]init] title:@"首页" image:@"tab_cummunity_normal" selectedImage:@"tab_cummunity_selected" imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)addCameraController {
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, 0);
    
    [self addChildViewController:[[ZENCameraViewController alloc]init] title:@"合成" image:@"tab_home_normal" selectedImage:@"tab_home_selected" imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)addMineController {
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, 0);
    
    [self addChildViewController:[[ZENMineViewController alloc]init] title:@"我" image:@"tab_mine_normal" selectedImage:@"tab_mine_selected" imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
