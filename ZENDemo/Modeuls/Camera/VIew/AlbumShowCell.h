//
//  AlbumShowCell.h
//  获取相册Demo
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface AlbumShowCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (assign, nonatomic) BOOL   isSelect;
- (void)applyData:(ALAsset *)asset andIsVideo:(BOOL)isVideo;

@end
