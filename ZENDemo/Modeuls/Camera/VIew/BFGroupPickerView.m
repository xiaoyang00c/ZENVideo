//
//  BFGroupPickerView.m
//  BuFu
//
//  Created by Andy on 16/5/24.
//  Copyright © 2016年 Hangzhou Huifeng Technology Co., Ltd. All rights reserved.
//

#import "AssetsGroupCell.h"
#import "BFGroupPickerView.h"

#define BounceAnimationPixel 5
#define NavigationHeight 64
@implementation BFGroupPickerView

- (void)removeNoDataGroup
{
//    for (ALAssetsGroup *gg in self.groups) {
//        if ([gg numberOfAssets]==0) {
//            [self.groups removeObject:gg];
//        }
//    }
}

- (id)initWithGroups:(NSMutableArray *)groups
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.groups = groups;
        [self removeNoDataGroup];
        [self setupLayout];
        [self setupTableView];
        [self addObserver:self forKeyPath:@"groups" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"groups"];
}

- (void)setupLayout
{
    self.frame = CGRectMake(0, - ScreenHeight+64, ScreenWidth, ScreenHeight-64);
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
}


- (void)reloadData
{
    [self removeNoDataGroup];
    [self.tableView reloadData];
}
- (void)show
{
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = CGRectMake(0, BounceAnimationPixel , ScreenWidth, ScreenHeight-64);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f delay:0.f options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.frame = CGRectMake(0, 64 , ScreenWidth, ScreenHeight-64);
        } completion:^(BOOL finished) {
        }];
    }];
    self.isOpen = YES;
}
- (void)dismiss:(BOOL)animated
{
    if (!animated)
    {
        self.frame = CGRectMake(0, -ScreenHeight+64, ScreenWidth, ScreenHeight-64);
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, - ScreenHeight+64, ScreenWidth, ScreenHeight-64);
        } completion:^(BOOL finished) {
        }];
    }
    self.isOpen = NO;
    
}

- (void)toggle
{
    if(self.frame.origin.y <0)
    {
        [self show];
    }
    else
    {
        [self dismiss:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"AssetsGroupCell";
    AssetsGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AssetsGroupCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell applyData:[self.groups objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.blockTouchCell)
        self.blockTouchCell(indexPath.row);
}

@end








