//
//  AlbumVideoViewController.m
//  testt
//
//  Created by Andy on 15/8/17.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AlbumShowCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVAsset.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "AlbumVideoViewController.h"
#import "BFNoDataView.h"
#import "BFGroupPickerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZENVideoEditViewController.h"



#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

#define LOCALVideoFILEPATH       [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/video"]

@interface AlbumVideoViewController ()<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>
{
    CHTCollectionViewWaterfallLayout *flowLayout;
    NSMutableArray  *selectedArray;
}
@property (strong, nonatomic) BFNoDataView *proView;
@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;


@property (strong, nonatomic) BFGroupPickerView *groupPicker;
@property (strong, nonatomic) UIButton *folderButton;

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, strong) AVMutableVideoComposition* videoComp;

@end

@implementation AlbumVideoViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^ {
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (AVMutableVideoComposition*)videoComp {
    if (!_videoComp) {
        _videoComp = [AVMutableVideoComposition videoComposition];
        _videoComp.frameDuration = CMTimeMake(1, 30);
        _videoComp.renderScale = 1.0;
    }
    return _videoComp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButton];
    
    self.assetsFilter = [ALAssetsFilter allVideos];
    selectedArray = [NSMutableArray array];
    
    
    [self collectionLayout];
    
    __weak typeof(self) weakSelf = self;
    [self setupGroup:^{
        [weakSelf.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } withSetupAsset:YES];
    
    [self.view addSubview:self.groupPicker];
    
    [self setNaviCenterView:self.folderButton];
    [self setNoNaviBackView];
    
    [self setRightBtnWithTitle:@"完成"];

}


- (void)rightButtonAction {
    
    if (selectedArray.count == 0) {
        [MBProgressHUD showError:@"请至少选择5段视频" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessag:@"正在合成" toView:self.navigationController.view];

    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //合成音频轨道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //合成视频轨道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [self videoComp];
    
    CMTime totalDuration = kCMTimeZero;
    NSMutableArray *videoLayerInstructions = [NSMutableArray array];

    NSUInteger i = 0;
    for (NSIndexPath *indexPath in selectedArray) {
        
        
        NSURL *url = [self.assets[indexPath.row] valueForProperty:ALAssetPropertyAssetURL];
        AVAsset *asset = [AVAsset assetWithURL:url];
        if (!asset) {
            continue;
        }
    
        CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,asset.duration);

        // audio 插入到 AVMutableCompositionTrack
        [audioTrack insertTimeRange:video_timeRange
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];

        //video 插入到 AVMutableCompositionTrack
        [videoTrack insertTimeRange:video_timeRange
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
        
        CGSize videoSize = videoTrack.naturalSize;
        AVAssetTrack *videoTrack1 = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        CGAffineTransform t = videoTrack1.preferredTransform;
        if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
           (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)){
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
        mixComposition.naturalSize = videoSize;
        _videoComp.renderSize = videoSize;

        AVMutableVideoCompositionInstruction* compositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        compositionInstruction.timeRange = CMTimeRangeMake(totalDuration, asset.duration);
        
        AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        //此处可定义多个AVMutableVideoCompositionLayerInstruction动画,用来做动画衔接
        //动画放至此 compositionInstruction.layerInstructions = @【动画123】
        Float64 assetDuration = CMTimeGetSeconds(asset.duration);
        Float64 totalDurationF = CMTimeGetSeconds(totalDuration);
        
        if ( _type <= ZENCameraEffType_WaterMarkAnimation) {
            if (_type > ZENCameraEffType_None) {
                
//                UIImage* waterImg = [UIImage imageNamed:@"waterMark"];
                CGSize videoSize = _videoComp.renderSize;
                //添加水印
                CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
                [subtitle1Text setFont:@"Helvetica-Bold"];
                [subtitle1Text setFontSize:30];
                [subtitle1Text setFrame:CGRectMake(0, 0, videoSize.width/2, videoSize.height/4)];
                [subtitle1Text setString:@"我是水印"];
                [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
                [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
                
                CALayer* aLayer = [CALayer layer];
                [aLayer addSublayer:subtitle1Text];
                aLayer.frame = CGRectMake (videoSize.width/4, videoSize.height*3/4, videoSize.width/2, videoSize.height/4);
                [aLayer setMasksToBounds:YES];
                
                CALayer *parentLayer = [CALayer layer];
                CALayer *videoLayer = [CALayer layer];
                parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
                videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
                [parentLayer addSublayer:videoLayer];
                [parentLayer addSublayer:aLayer];
                
                if (_type == ZENCameraEffType_WaterMarkAnimation) {
                    
                    //水印动画
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    [animation setDuration:0.5];
                    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
                    [animation setToValue:[NSNumber numberWithFloat:0.2]];
                    [animation setBeginTime:2];
                    [animation setRepeatCount:1000000];
                    animation.autoreverses = YES;
                    [animation setFillMode:kCAFillModeForwards];
                    [subtitle1Text addAnimation:animation forKey:@"animateOpacity"];
                    
                }
                
                _videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
                

            }
        }
        else if (_type == ZENCameraEffType_VideoOpacity) {

            [layerInstruction setOpacityRampFromStartOpacity:0.1f toEndOpacity:1.0f timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(totalDurationF, 30), CMTimeMakeWithSeconds( 2 + totalDurationF, 30))];
        }
        else if(_type == ZENCameraEffType_VideoCrop) {
            CMTimeRange timeRange =   compositionInstruction.timeRange;
            CGRect startRect = CGRectMake(0.0f, 0.0f, videoSize.width, videoSize.height);
            CGRect endRect = CGRectMake(0.0f, videoSize.height, videoSize.width, 0.0f);
            [layerInstruction setCropRectangleRampFromStartCropRectangle:startRect
                                               toEndCropRectangle:endRect
                                                        timeRange:timeRange];
        }
        else if(_type == ZENCameraEffType_VideoPushFromRight) {
            if (i == 0 && selectedArray.count > 1) {
                [layerInstruction setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0) timeRange:
                 CMTimeRangeMake(CMTimeMakeWithSeconds(assetDuration - 2 + totalDurationF, 30), CMTimeMakeWithSeconds(assetDuration - 1 + totalDurationF, 30))];
            }else{
//                Float64 totalDurationF = CMTimeGetSeconds(totalDuration);
//                [layerInstruction setTransform:CGAffineTransformIdentity atTime:kCMTimeZero];
//                [layerInstruction setTransformRampFromStartTransform:CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0) toEndTransform:CGAffineTransformIdentity timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(totalDurationF + 0.1, 30), CMTimeMakeWithSeconds(totalDurationF + 1.1, 30))];
            }
        }
        compositionInstruction.layerInstructions = @[layerInstruction];
        [videoLayerInstructions addObject:compositionInstruction];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        i++;
    }

    _videoComp.instructions = videoLayerInstructions;
    

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/video",cachePath];
    BOOL isDir =NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if ( !(isDir ==YES && existed == YES) ){//如果没有文件夹则创建
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *fileName = [NSString stringWithFormat:@"%.0f.mp4",interval];
    NSString *videoFilePath = [filePath stringByAppendingPathComponent:fileName];
    
    __weak typeof (&*self)weakSelf = self;
    AVAssetExportSession *exporterSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset1280x720];
    exporterSession.videoComposition = self.videoComp;
    exporterSession.outputFileType = AVFileTypeQuickTimeMovie;
    exporterSession.outputURL = [NSURL fileURLWithPath:videoFilePath];//如果文件已存在，将造成导出失败
    exporterSession.shouldOptimizeForNetworkUse = YES; //用于互联网传输
    [exporterSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        });
        switch (exporterSession.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"exporter Failed");
                NSLog(@"%@",exporterSession.error);
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                
                __weak typeof (&*weakSelf)strongSelf = weakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"合成成功" toView:weakSelf.view];
                    ZENVideoEditViewController *controller = [[ZENVideoEditViewController alloc] init];
                    controller.videoURL = [NSURL fileURLWithPath:videoFilePath];
                    [strongSelf.navigationController pushViewController:controller animated:YES];
                });
                break;
        }
    }];
}



- (void)collectionLayout
{
    flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    flowLayout.minimumColumnSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    flowLayout.columnCount = 3;
    
    _videoCollectionView.collectionViewLayout = flowLayout;
    _videoCollectionView.showsVerticalScrollIndicator = NO;
    _videoCollectionView.delegate = self;
    [_videoCollectionView registerClass:[AlbumShowCell class] forCellWithReuseIdentifier:@"AlbumShowCell"];
}


- (void)setupGroup:(void (^) ())endblock withSetupAsset:(BOOL)doSetupAsset
{
    if (!self.assetsLibrary)
    {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    
    __weak typeof(self) weakSelf = self;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [group setAssetsFilter:self.assetsFilter];
            if (group.numberOfAssets) {
                NSInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
                if(groupType == ALAssetsGroupSavedPhotos)
                {
                    [weakSelf.groups insertObject:group atIndex:0];
                    if(doSetupAsset)
                    {
                        weakSelf.assetsGroup = group;
                        [weakSelf setupAssets:nil];
                    }
                }
                else
                {
                    if (group.numberOfAssets > 0)
                        [weakSelf.groups addObject:group];
                }
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.groupPicker reloadData];
                if(endblock)
                    endblock();
            });
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //不允许
        [self.view addSubview:self.proView];
        self.folderButton.userInteractionEnabled = NO;
        self.folderButton.hidden = YES;
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

- (void)setupAssets:(void (^) ())successBlock
{
    [_folderButton setTitle:[NSString stringWithFormat:@" %@",[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]] forState:UIControlStateNormal];
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    if(!self.assetsGroup)
    {
        self.assetsGroup = self.groups[0];
    }
    [self.assetsGroup setAssetsFilter:self.assetsFilter];
    NSInteger assetCount = [self.assetsGroup numberOfAssets];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset)
        {
            [self.assets addObject:asset];
        }
        
        else if (self.assets.count >= assetCount)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
                if(successBlock)
                    successBlock();
            });
        }
    };
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultsBlock];
}

- (void)reloadData
{
    [_videoCollectionView reloadData];
    [self showNoAssetsIfNeeded];
}
- (void)showNoAssetsIfNeeded
{
    NSLog(@"没有");
}


#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"AlbumShowCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"AlbumShowCell"];
    AlbumShowCell *cell = [[AlbumShowCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumShowCell" forIndexPath:indexPath];
    ALAsset *videoasset = self.assets[indexPath.row];
    [cell applyData:videoasset andIsVideo:YES];
    
    cell.isSelect = [selectedArray containsObject:indexPath];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-12)/3, (ScreenWidth-12)/3);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [self.assets[indexPath.row] valueForProperty:ALAssetPropertyAssetURL];
    
    NSLog(@"\n%@",[url absoluteString]);
    
    if (![self checkVideoType:url]) {
        return ;
    }
    AVAsset *asset = [AVAsset assetWithURL:url];
    if (!asset) {
        return ;
    }
    
    if ([selectedArray containsObject:indexPath]) {
        [selectedArray removeObject:indexPath];
    }else
    {
        [selectedArray addObject:indexPath];
    }
    [collectionView reloadData];
    
}

#pragma mark 视频格式
- (BOOL)checkVideoType:(NSURL *)url
{
    if ([[url absoluteString] rangeOfString:@"mp4"].location == NSNotFound &&
        [[url absoluteString] rangeOfString:@"MP4"].location == NSNotFound &&
        [[url absoluteString] rangeOfString:@"MOV"].location == NSNotFound &&
        [[url absoluteString] rangeOfString:@"mov"].location == NSNotFound &&
        [[url absoluteString] rangeOfString:@"m4v"].location == NSNotFound &&
        [[url absoluteString] rangeOfString:@"M4V"].location == NSNotFound) {
        [MBProgressHUD showError:@"你所选的视频格式不正确" toView:self.view];

        return NO;
    }else{
        return YES;
    }
}



#pragma mark ------getter

- (UIButton *)folderButton
{
    if (_folderButton == nil) {
        _folderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _folderButton.frame = CGRectMake(ScreenWidth - 90, 20, 150, 44);
        _folderButton.center = CGPointMake(ScreenWidth/2, _folderButton.center.y);
        [_folderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _folderButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_folderButton addTarget:self action:@selector(clickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [_folderButton setImage:[UIImage imageNamed:@"camera_album_down"] forState:UIControlStateNormal];
    }
    return _folderButton;
}
- (void)clickCenterButton
{
    [self.groupPicker toggle];
}

- (BFGroupPickerView *)groupPicker
{
    if (_groupPicker == nil) {
        __weak typeof(self) weakSelf = self;
        _groupPicker = [[BFGroupPickerView alloc] initWithGroups:self.groups];
        [self.groupPicker setBlockTouchCell:^(NSInteger row) {
            [weakSelf changeGroup:row filter:weakSelf.assetsFilter];
        }];
    }
    return _groupPicker;
}

- (void)changeGroup:(NSInteger)item filter:(ALAssetsFilter *)filter
{
    self.assetsFilter = filter;
    self.assetsGroup = self.groups[item];
    [self setupAssets:nil];
    [self.groupPicker.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.groupPicker dismiss:YES];
}

- (BFNoDataView *)proView
{
    if (_proView == nil) {
        _proView = [[[NSBundle mainBundle] loadNibNamed:@"BFNoDataView" owner:self options:nil] lastObject];
        _proView.backgroundColor = self.view.backgroundColor;
        _proView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        [_proView fillData:@"common_video_public_no" andProTitle:@"请去设置隐私打开相册权限" andBtnTitle:@"" andTHeight:0 andBHeight:0];
        [_proView setBlockAction:^{
        }];
    }
    return _proView;
}


- (void)dealloc
{
    _videoCollectionView.delegate = nil;
    _videoCollectionView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (AVMutableVideoComposition *)getVideoComposition:(AVAsset *)asset {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    CGSize videoSize = videoTrack.naturalSize;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
           (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)){
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
    }
    composition.naturalSize    = videoSize;
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMakeWithSeconds( 1 / videoTrack.nominalFrameRate, 600);
    
    AVMutableCompositionTrack *compositionVideoTrack;
    compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *layerInst;
    layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInst setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    return videoComposition;
}

- (void)lowQuailtyWithInputURL:(NSURL *)inputURL blockHandler:(void (^)(AVAssetExportSession *session, NSURL *compressionVideoURL))handler {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset1280x720];
    NSString *path = [NSString stringWithFormat:@"%@VideoCompression/",NSTemporaryDirectory()];
    
    NSFileManager *fileManage = [[NSFileManager alloc] init];    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:path]){
            [fileManage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    if([fileManage fileExistsAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]]){
        [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path] error:nil];
    }
    
    __weak typeof (&*self)weakSelf = self;
    NSURL *compressionVideoURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path]];
    session.outputURL = compressionVideoURL;
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    session.videoComposition = [self getVideoComposition:asset];
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            switch ([session status]) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"exporter Unknow");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"exporter Canceled");
                    break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"exporter Failed");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"exporter Waiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"exporter Exporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"exporter Completed");
                    __weak typeof (&*weakSelf)strongSelf = weakSelf;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ZENVideoEditViewController *controller = [[ZENVideoEditViewController alloc] init];
                        controller.videoURL = [NSString stringWithFormat:@"%@VideoCompressionTemp.mp4",path];
                        [strongSelf.navigationController pushViewController:controller animated:YES];
                    });
                    break;
            }
        });
    }];
}

@end

