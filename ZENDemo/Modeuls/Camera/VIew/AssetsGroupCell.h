//
//  AssetsGroupCell.h
//  BuFu
//
//  Created by Andy on 16/5/24.
//  Copyright © 2016年 Hangzhou Huifeng Technology Co., Ltd. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface AssetsGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *paperImgV;
@property (weak, nonatomic) IBOutlet UILabel *groupL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
- (void)applyData:(ALAssetsGroup *)assetsGroup;

@end
