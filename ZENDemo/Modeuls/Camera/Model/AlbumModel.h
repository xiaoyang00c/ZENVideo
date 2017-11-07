//
//  AlbumModel.h
//  获取相册Demo
//
//  Created by Andy on 15/7/23.
//  Copyright © 2015年 Andy. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,copy) NSString *choiceStatus;
@property (nonatomic,strong) UIImage *showImage;

@property (nonatomic,copy) NSString *videoName;

- (instancetype)initWithAlbumModelWith:(ALAsset *)albumAsset;

@end
