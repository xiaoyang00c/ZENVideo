//
//  AssetsGroupCell.m
//  BuFu
//
//  Created by Andy on 16/5/24.
//  Copyright © 2016年 Hangzhou Huifeng Technology Co., Ltd. All rights reserved.
//

#import "AssetsGroupCell.h"

@implementation AssetsGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)applyData:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / 70;
    
    self.paperImgV.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.groupL.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.numL.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
