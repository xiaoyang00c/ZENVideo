//
//  BFGroupPickerView.h
//  BuFu
//
//  Created by Andy on 16/5/24.
//  Copyright © 2016年 Hangzhou Huifeng Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFGroupPickerView : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic,copy) void(^blockTouchCell)(NSInteger);
@property (nonatomic,assign) BOOL isOpen;
- (id)initWithGroups:(NSMutableArray *)groups;
- (void)dismiss:(BOOL)animated;
- (void)toggle;
- (void)reloadData;

@end
