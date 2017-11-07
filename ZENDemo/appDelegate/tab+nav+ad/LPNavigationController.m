//
//  LPNavigationController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNavigationController.h"
#import "UIImage+Mycategory.h"

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

@interface LPNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
// 记录push标志
@property (nonatomic, getter=isPushing) BOOL pushing;

@end

@implementation LPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableRightGesture = YES;
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self configureNavBarTheme];
}

- (void)configureNavBarTheme
{
    self.navigationBar.tintColor = SHColor_text;
    // 设置导航栏的标题颜色，字体
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [UIColor whiteColor]];
    [shadow setShadowOffset: CGSizeMake(0.5f, 0.0f)];
    [self.navigationBar setTitleTextAttributes:
     @{ NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:18.f],
        NSShadowAttributeName: shadow}];

    //设置导航栏的背景图片
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationBar setBackgroundImage:[[UIImage imageWithColor:SHColor_navbkg size:CGSizeMake(ScreenWidth, 3)] stretchableImageWithLeftCapWidth:100.f topCapHeight:1] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏底部阴影
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithRed:0.87 green:0.88 blue:0.90 alpha:0.9] size:CGSizeMake(ScreenWidth, 1)]];
    

    
//    self.navigationBar.translucent = YES;
//    // blur效果
//    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    visualEfView.frame = CGRectMake(0, -20, CGRectGetWidth(self.navigationBar.frame), CGRectGetHeight(self.navigationBar.frame)+21);
//    visualEfView.alpha = 1.0;
//    [self.navigationBar insertSubview:visualEfView atIndex:0];
    
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = (CGRect){CGPointZero,CGSizeMake(1.0, 1.0)};
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return self.enableRightGesture;
}

#pragma mark - override

// override pushViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [leftButton setImage:ImageNamed(@"nav_bar_back") forState:UIControlStateNormal];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 让返回按钮内容继续向左边偏移10
        leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [leftButton addTarget:self action:@selector(navGoBack) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    if (self.pushing == YES) {
        NSLog(@"被拦截");
        return;
    } else {
        self.pushing = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - action

- (void)navGoBack
{
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.pushing = NO;
}
@end
