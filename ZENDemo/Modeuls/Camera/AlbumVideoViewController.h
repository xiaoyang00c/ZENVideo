//
//  AlbumVideoViewController.h
//  testt
//
//  Created by Andy on 15/8/17.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

//#import "ImportVideoViewController.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger,ZENCameraEffType){
    ZENCameraEffType_None = 0,
    ZENCameraEffType_WaterMark,
    ZENCameraEffType_WaterMarkAnimation,
};



@interface AlbumVideoViewController : BaseViewController

@property (nonatomic,assign) ZENCameraEffType type;

@end
