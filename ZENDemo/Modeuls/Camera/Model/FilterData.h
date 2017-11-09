//
//  FilterData.h
//  ZENDemo
//
//  Created by Andy on 2017/11/8.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FilterData : JSONModel
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* value;
@property (nonatomic,copy) NSString* fillterName;
@property (nonatomic,copy) NSString* iconPath;
@property (nonatomic,assign) BOOL isSelected;
@end
