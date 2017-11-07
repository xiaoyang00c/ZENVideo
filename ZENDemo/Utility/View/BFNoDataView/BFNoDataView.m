//
//  BFNoDataView.m
//  BuFu
//
//  Created by Andy on 15/9/21.
//  Copyright (c) 2015年 Hangzhou Huifeng Technology Co., Ltd. All rights reserved.
//

#import "BFNoDataView.h"

@implementation BFNoDataView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
//    _titleL.textColor = BFColor_23232B;
//    _actionBtn.backgroundColor = BFColor_E23C50;
//    _actionBtn.layer.cornerRadius = 5;
//    _actionBtn.clipsToBounds = YES;
    _statusImgV.userInteractionEnabled = NO;
    _statusImgV.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)fillData:(NSString *)imageName andProTitle:(NSString *)title andBtnTitle:(NSString *)btntitle andTHeight:(NSInteger)height1 andBHeight:(NSInteger)height2
{
    if (height1 == 0 || height2 == 0) {
        _theightConstraint.constant = 7*ScreenWidth/375;
        _bheightConstraint.constant = 20*ScreenWidth/375;
    }else {
        _theightConstraint.constant = height1*ScreenWidth/375;
        _bheightConstraint.constant = height2*ScreenWidth/375;
    }
    
    if ([judgeStr(btntitle) isEqualToString:@""]) {
        _actionBtn.hidden = YES;
    }else
    {
        _actionBtn.hidden = NO;
    }
    
    [_statusImgV setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _titleL.text = title;
    [_actionBtn setTitle:btntitle forState:UIControlStateNormal];
}


- (void)fillProTitle:(NSString*)title actionImage:(NSString*)image
{
    _titleL.text = title;
    [_actionBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)updateNodataTipWith:(NSString *)title
{
    _titleL.text = title;
    _actionBtn.hidden = YES;
}


- (IBAction)BtnClickAction:(id)sender {
    if (_blockAction) {
        _blockAction();
    }
}



- (void)dasd
{
    
}


@end











