//
//  BaseViewController.m
//  BuFu
//
//  Created by Andy on 15/4/21.
//  Copyright (c) 2015年 Huifeng Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIButton *rightButton;
    UIButton *rightButton2; //右边第二个按钮
    UIButton *leftButton;
    UIButton *norbackButton;
}

//导航栏中间文本
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation BaseViewController

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHColor_background;
    [self.view addSubview:self.bgView];
    [_bgView addSubview:self.titleLabel];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window) {
        // 目的是再次进入时能够重新加载调用viewDidLoad函数
//        self.view = nil;
    }
}

- (void)setNaviTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
- (void)setNaviCenterView:(id)centerView
{
    [self.bgView addSubview:centerView];
}
- (void)setRitghtCustomView:(id)rightView
{
    [self.bgView addSubview:rightView];
}

- (void)setBackButton
{
    norbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [norbackButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
//    norbackButton.backgroundColor = [UIColor redColor];
    
    [norbackButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    norbackButton.frame = CGRectMake(0, CGRectGetHeight(_bgView.frame)-44, 64, 44);
    norbackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [norbackButton setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    [_bgView addSubview:norbackButton];
}
- (void)clickBackButton
{

    [self leftButtonAction];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackButtonWithTitle:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(13, CGRectGetHeight(_bgView.frame)-44, 80, 44);
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitleColor:SHColor_text forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [backButton addTarget:self action:@selector(clickDissmissButton) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgView addSubview:backButton];
}

- (void)clickDissmissButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




//左边按钮(文字)
- (void)setLeftBtnWithTitle:(NSString *)title
{
    if (leftButton == nil) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [leftButton setTitleColor:SHColor_text forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    leftButton.frame = CGRectMake(13, CGRectGetHeight(_bgView.frame)-44, 80, 44);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bgView addSubview:leftButton];
}
//左边按钮(图片)
- (void)setLeftBtnWithImageName:(NSString *)imageName
{
    if (leftButton == nil) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    leftButton.backgroundColor = [UIColor redColor];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.frame = CGRectMake(10, 20, 44, 44);
    leftButton.frame = CGRectMake(0, CGRectGetHeight(_bgView.frame)-44, 64, 44);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bgView addSubview:leftButton];
}

//去掉左边按钮
- (void)removeLeftButton
{
    if (leftButton) {
        [leftButton removeFromSuperview];
    }
}

//去掉右边按钮
- (void)removeRightButton
{
    if (rightButton) {
        [rightButton removeFromSuperview];
    }
}

- (void)leftButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setRightBtnWithTitle:(NSString *)title
{
    if (rightButton == nil) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    rightButton.frame = CGRectMake(ScreenWidth - 93, CGRectGetHeight(_bgView.frame)-44, 93, 44);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 13)];
    [self.bgView addSubview:rightButton];
}

- (void)setRightBtnWithImageName:(NSString *)imageName
{
    if (rightButton == nil) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setImage:image forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(MYSCREENWIDTH - image.size.width - 10, 20 + (44 - image.size.height)/2, image.size.width, image.size.height);
    rightButton.frame = CGRectMake(ScreenWidth - 50, CGRectGetHeight(_bgView.frame)-44, 50, 44);
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 13)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.bgView addSubview:rightButton];
}

- (void)setSecondRightBtnWithImageName:(NSString *)imageName
{
    if (rightButton2 == nil) {
        rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [rightButton2 setImage:image forState:UIControlStateNormal];
    [rightButton2 setImage:image forState:UIControlStateHighlighted];
    [rightButton2 addTarget:self action:@selector(secondRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.frame = CGRectMake(ScreenWidth - 50 - 50, CGRectGetHeight(_bgView.frame)-44, 50, 44);
    rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.bgView addSubview:rightButton2];
}



- (void)setRightBtnDisEnabel
{
    rightButton.userInteractionEnabled = NO;
}
- (void)setRightBtnEnabel
{
    rightButton.userInteractionEnabled = YES;
}
//右边按钮的点击事件   可在子类里重写
- (void)rightButtonAction
{

}

- (void)secondRightButtonAction
{
    
}

- (CGFloat)getNaviHeight
{
    return 64;
}

- (void)setNavibarBackImage
{
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [norbackButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)setNoNaviBackView
{
    [self setNavibarBackImage];
    _bgView.backgroundColor = SHColor_navbkg;
    [_naviBottomLine removeFromSuperview];
}

- (void)setNavibarBackGroundColor:(UIColor *)color
{
//    [_naviBottomLine removeFromSuperview];
    _bgView.backgroundColor = color;
    //    self.titleLabel.textColor = [UIColor colorWithRed:0.34f green:0.34f blue:0.34f alpha:1.00f];
    self.naviBottomLine.hidden = NO;
    if (CGColorGetAlpha(color.CGColor) < 0.5) {
        self.naviBottomLine.hidden = YES;
    }
}


- (void)HiddenNavibar
{
    _bgView.hidden = YES;
}

- (UIView *)naviBottomLine
{
    if (_naviBottomLine==nil) {
        _naviBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame)-0.5, ScreenWidth, 0.5)];
        _naviBottomLine.backgroundColor = [UIColor clearColor];
    }
    return _naviBottomLine;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
//        [_bgView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        _bgView.backgroundColor = SHColor_navbkg;
        _bgView.userInteractionEnabled = YES;
        [_bgView addSubview:self.naviBottomLine];
        
        /*
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [visualEffectView setFrame:_bgView.bounds];
        visualEffectView.alpha = 1.0;
        [_bgView insertSubview:visualEffectView atIndex:0];
        */
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetHeight(_bgView.frame)-44, ScreenWidth/2, 44)];
        _titleLabel.center = CGPointMake(ScreenWidth/2, _titleLabel.center.y);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)hiddenRightBtnAction
{
    [rightButton removeFromSuperview];
    rightButton = nil;
}

- (void)setRightBtnTitleWithColor:(UIColor *)color
{
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    [rightButton setTitleColor:color forState:UIControlStateHighlighted];
}

-(void)showNaviBar
{
    [self HiddenNavibar];
}


- (void)naviButtonClickActionWith:(NSInteger)buttonTag
{
    if (buttonTag==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (buttonTag==3)
    {
        
    }
}

- (void)viewWillLayoutSubviews
{
    _titleLabel.frame = CGRectMake(ScreenWidth/2, CGRectGetHeight(_bgView.frame)-44, ScreenWidth/2, 44);
    _titleLabel.center = CGPointMake(ScreenWidth/2, _titleLabel.center.y);
    _naviBottomLine.frame = CGRectMake(0, CGRectGetHeight(_bgView.frame)-0.5, ScreenWidth, 0.5);
}


- (void)showNaviBottomImage{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.frame.size.height-2.5, ScreenWidth, 2.5)];
    bottomView.backgroundColor = SHColor_light;
    [_bgView addSubview:bottomView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 119, 2.5)];
    imageView.center = CGPointMake(ScreenWidth/2, imageView.center.y);
    imageView.image = [UIImage imageNamed:@"tab_selected_bkg"];
    [bottomView addSubview:imageView];
}

- (void)setNaviWhiteStyle
{
    _bgView.backgroundColor = [UIColor clearColor];
    [norbackButton setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
    _titleLabel.textColor = [UIColor whiteColor];
    
}





@end







