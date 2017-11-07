//
//  ZENMineViewController.m
//  ZENDemo
//
//  Created by Andy on 2017/11/7.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "ZENMineViewController.h"

@interface ZENMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *videos;

@end



@implementation ZENMineViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.videos = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = SHColor_separator;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    __weak  typeof(&*self) weakSelf = self;
    self.tableView.mj_header = [BBRGIFHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];

}

- (void)loadData {
    
    [_videos removeAllObjects];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/video",cachePath];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    
    while ((filename = [e nextObject])) {
        if ([filename rangeOfString:@".mp4"].location != NSNotFound ) {
            [self.videos addObject:filename];
        }
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableView dateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString    *identifier = @"identifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = _videos[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = SHColor_text;
    cell.detailTextLabel.textColor = SHColor_light;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    /*使分割线伸展*/
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark --
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
