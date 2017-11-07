//
//  AlbumModel.m
//  获取相册Demo
//
//  Created by Andy on 15/7/23.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

@synthesize choiceStatus,showImage,videoName;

- (instancetype)initWithAlbumModelWith:(ALAsset *)albumAsset
{
    if (self = [super init]) {
        self.choiceStatus = @"0";
        self.asset = albumAsset;
    }
    return self;
}

@end
