//
//  BFNoDataView.h
//  BuFu
//
//  Created by Andy on 15/9/21.
//  Copyright (c) 2015年 Hangzhou Huifeng Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFNoDataView : UIView

@property (weak, nonatomic) IBOutlet UIButton *statusImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bheightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@property (nonatomic,copy) void(^blockAction)();


- (void)fillData:(NSString *)imageName andProTitle:(NSString *)title andBtnTitle:(NSString *)btntitle andTHeight:(NSInteger)height1 andBHeight:(NSInteger)height2;

- (void)fillProTitle:(NSString*)title actionImage:(NSString*)image;

- (void)updateNodataTipWith:(NSString *)title;

@end
