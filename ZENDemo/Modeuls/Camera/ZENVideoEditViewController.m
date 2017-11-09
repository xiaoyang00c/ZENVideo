//
//  ZENVideoEditViewController.m
//  ZENDemo
//
//  Created by Andy on 2017/11/7.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "ZENVideoEditViewController.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayerLayer.h>
#import "GPUImage.h"
#import "FilterData.h"
#import "LFGPUImageEmptyFilter.h"
#import "MusicItemCollectionViewCell.h"


@interface ZENVideoEditViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL isSaved;
    
    GPUImageMovie *movieFile;
    GPUImageMovie* endMovieFile;
    GPUImageOutput<GPUImageInput> *filter;

    UIImageView* playImg;
    
    GPUImageMovieWriter *movieWriter;
}
@property (nonatomic,strong) UIView *videoContrainerView;

@property (nonatomic,strong) AVPlayerItem *playerItm;
@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSMutableArray* filterAry;
@property (nonatomic ,strong) NSString* filtClassName;
@property (nonatomic ,strong) GPUImageView *filterView;

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSIndexPath* lastFilterIndex;
@property (nonatomic ,strong) NSIndexPath* nowFilterIndex;
@property (nonatomic ,assign) float saturationValue;


@end

@implementation ZENVideoEditViewController


- (void)pressPlayButton
{
    [self.playerItm seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)playingEnd:(NSNotification *)notification
{
    __weak typeof(&*self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf pressPlayButton];
        [movieFile startProcessing];
    });
}

- (void)onApplicationWillResignActive
{
    [self.player pause];
    [movieFile endProcessing];
}

- (void)onApplicationDidBecomeActive
{
    [self.playerItm seekToTime:kCMTimeZero];
    [self.player play];
    [movieFile startProcessing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player pause];
    [movieFile endProcessing];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(&*self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.player play];
        [movieFile startProcessing];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCloseCor) name:@"closeVideoCamerTwo" object:nil];
}


- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

-(FilterData*)createWithName:(NSString* )name andFlieName:(NSString*)fileName andValue:(NSString*)value
{
    FilterData* filter1 = [[FilterData alloc] init];
    filter1.name = name;
    filter1.iconPath =  [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    filter1.fillterName = fileName;
    if (value) {
        filter1.value = value;
    }
    return filter1;
}

-(NSArray*)creatFilterData
{
    FilterData* filter1 = [self createWithName:@"Empty" andFlieName:@"LFGPUImageEmptyFilter" andValue:nil];
    filter1.isSelected = YES;
    FilterData* filter2 = [self createWithName:@"Amatorka" andFlieName:@"GPUImageAmatorkaFilter" andValue:nil];
    FilterData* filter3 = [self createWithName:@"MissEtikate" andFlieName:@"GPUImageMissEtikateFilter" andValue:nil];
    FilterData* filter4 = [self createWithName:@"Sepia" andFlieName:@"GPUImageSepiaFilter" andValue:nil];
    FilterData* filter5 = [self createWithName:@"Sketch" andFlieName:@"GPUImageSketchFilter" andValue:nil];
    FilterData* filter6 = [self createWithName:@"SoftElegance" andFlieName:@"GPUImageSoftEleganceFilter" andValue:nil];
    FilterData* filter7 = [self createWithName:@"Toon" andFlieName:@"GPUImageToonFilter" andValue:nil];
    
    FilterData* filter8 = [[FilterData alloc] init];
    filter8.name = @"Saturation0";
    filter8.iconPath = [[NSBundle mainBundle] pathForResource:@"GPUImageSaturationFilter0" ofType:@"png"];
    filter8.fillterName = @"GPUImageSaturationFilter";
    filter8.value = @"0";
    
    FilterData* filter9 = [[FilterData alloc] init];
    filter9.name = @"Saturation2";
    filter9.iconPath = [[NSBundle mainBundle] pathForResource:@"GPUImageSaturationFilter2" ofType:@"png"];
    filter9.fillterName = @"GPUImageSaturationFilter";
    filter9.value = @"2";
    
    return [NSArray arrayWithObjects:filter1,filter2,filter3,filter4,filter5,filter6,filter7,filter8,filter9, nil];
    
}


- (void)config {
    _filterAry = [NSMutableArray arrayWithArray:[self creatFilterData]];
}

- (UICollectionView*)collectionView {
    
    if (!_collectionView) {
        //collectionView
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(83, 115);
        layout.estimatedItemSize = CGSizeMake(83, 115);
        
        //水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 设置额外滚动区域
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        // 设置cell间距
        //设置水平间距, 注意点:系统可能会跳转(计算不准确)
        layout.minimumInteritemSpacing = 0;
        //设置垂直间距
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 115 - 60, ScreenWidth, 115) collectionViewLayout:layout];
        
        //设置背景颜色
        _collectionView.backgroundColor = [UIColor clearColor];
        
        
        // 设置数据源,展示数据
        _collectionView.dataSource = self;
        //设置代理,监听
        _collectionView.delegate = self;
        
        // 注册cell
        [_collectionView registerClass:[MusicItemCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
        
        /* 设置UICollectionView的属性 */
        //设置滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //设置是否需要弹簧效果
        _collectionView.bounces = YES;
        
        [self.view addSubview:_collectionView];
    
    }
    return _collectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_interactivePopDisabled = YES;
    [self config];
    
    _videoContrainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _videoContrainerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_videoContrainerView];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoURL];
    self.playerItm = item;
    AVPlayer *tmpPlayer = [AVPlayer playerWithPlayerItem:item];
    self.player = tmpPlayer;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.videoContrainerView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    [self.videoContrainerView.layer addSublayer:_playerLayer];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];

//    [self.player play];
    
    
    movieFile = [[GPUImageMovie alloc] initWithPlayerItem:item];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = YES;
    
    filter = [[LFGPUImageEmptyFilter alloc] init];

    _filtClassName = @"LFGPUImageEmptyFilter";
    [movieFile addTarget:filter];
    _filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _filterView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_filterView];
    [filter addTarget:_filterView];
    
    
    [self collectionView];
    
    
    UIButton    *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:ImageNamed(@"nav_bar_back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    UIButton    *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/4, 0, ScreenWidth/2, 40)];
    [saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
    [saveButton setTitleColor:SHColor_light forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    saveButton.layer.borderColor = SHColor_light.CGColor;
    saveButton.layer.borderWidth = 1;
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    [self.view addSubview:saveButton];
    [saveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [saveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [saveButton autoSetDimensionsToSize:CGSizeMake(ScreenWidth/2, 40)];
    
}


- (void)backButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveButtonClicked {
    if (isSaved) {
        [MBProgressHUD showError:@"已保存过了" toView:self.view];
        return;
    }
    if (_videoURL) {
        
        [self mixFiltWithVideoAndInputVideoURL:self.videoURL];
        
    }
}

//保存视频完成之后的回调
- (void) video:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
        [MBProgressHUD showError:@"保存失败" toView:self.view];
    }
    else {
        NSLog(@"保存视频成功");
        [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
        isSaved = YES;
    }
}


-(void)mixFiltWithVideoAndInputVideoURL:(NSURL*)inputURL;
{
    [MBProgressHUD showMessag:@"滤镜合成中..." toView:self.navigationController.view];

    endMovieFile = [[GPUImageMovie alloc] initWithURL:inputURL];
    endMovieFile.runBenchmark = YES;
    endMovieFile.playAtActualSpeed = NO;
    
    GPUImageOutput<GPUImageInput> *endFilter;
    if ([_filtClassName isEqualToString:@"GPUImageSaturationFilter"]) {
        GPUImageSaturationFilter* xxxxfilter = [[NSClassFromString(_filtClassName) alloc] init];
        xxxxfilter.saturation = _saturationValue;
        endFilter = xxxxfilter;
        
    }else{
        endFilter = [[NSClassFromString(_filtClassName) alloc] init];
    }
    
    [endMovieFile addTarget:endFilter];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/Movie.mp4"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280.0, 720)];
    [endFilter  addTarget:movieWriter];
    movieWriter.shouldPassthroughAudio = YES;
    endMovieFile.audioEncodingTarget = movieWriter;
    [endMovieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    [movieWriter startRecording];
    [endMovieFile startProcessing];
    __weak GPUImageMovieWriter *weakmovieWriter = movieWriter;
    typeof(self) __weak weakself = self;
    [movieWriter setCompletionBlock:^{
        [endFilter removeTarget:weakmovieWriter];
        [weakmovieWriter finishRecording];
        [weakself compressVideoWithInputVideoUrl:movieURL];
    }];
    
    [movieWriter setFailureBlock:^(NSError *error){
        NSLog(@"失败了%@",error);
    }];
}




- (void)compressVideoWithInputVideoUrl:(NSURL *) inputVideoUrl
{
    __weak typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        [MBProgressHUD showSuccess:@"合成成功" toView:weakSelf.view];
        UISaveVideoAtPathToSavedPhotosAlbum([[inputVideoUrl absoluteString ] stringByReplacingOccurrencesOfString:@"file://" withString:@""], weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        
        __strong typeof(&*weakSelf)strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        });
        
        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([inputVideoUrl absoluteString])) {
//            UISaveVideoAtPathToSavedPhotosAlbum([inputVideoUrl absoluteString], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//        }
    });

    
    /*
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/video",cachePath];
    BOOL isDir =NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if ( !(isDir ==YES && existed == YES) ){//如果没有文件夹则创建
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *fileName = [NSString stringWithFormat:@"%lf.mp4",interval];
    NSString *videoFilePath = [filePath stringByAppendingPathComponent:fileName];
    

    NSDictionary* options = @{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
    AVAsset* asset = [AVURLAsset URLAssetWithURL:inputVideoUrl options:options];
    NSArray* keys = @[@"tracks",@"duration",@"commonMetadata"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        SDAVAssetExportSession *compressionEncoder = [SDAVAssetExportSession.alloc initWithAsset:asset]; // provide inputVideo Url Here
        compressionEncoder.outputFileType = AVFileTypeMPEG4;
        compressionEncoder.outputURL = [NSURL fileURLWithPath:videoFilePath]; //Provide output video Url here
        compressionEncoder.videoSettings = @
        {
        AVVideoCodecKey: AVVideoCodecH264,
        AVVideoWidthKey: @1280,   //Set your resolution width here
        AVVideoHeightKey: @720,  //set your resolution height here
        AVVideoCompressionPropertiesKey: @
            {
                //2000*1000  建议800*1000-5000*1000
                //AVVideoAverageBitRateKey: @2500000, // Give your bitrate here for lower size give low values
            AVVideoAverageBitRateKey: [NSNumber numberWithInteger:2500000],
            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
            AVVideoAverageNonDroppableFrameRateKey: [NSNumber numberWithInteger:30],
            },
        };
        compressionEncoder.audioSettings = @
        {
        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: @2,
        AVSampleRateKey: @44100,
        AVEncoderBitRateKey: @128000,
        };

        [compressionEncoder exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //更新UI操作
                 //.....
                 if (compressionEncoder.status == AVAssetExportSessionStatusCompleted)
                 {
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [MBProgressHUD showSuccess:@"合成成功" toView:self.view];

                         if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([inputVideoUrl absoluteString])) {
                             //保存相册核心代码
                             UISaveVideoAtPathToSavedPhotosAlbum([inputVideoUrl absoluteString], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                         }
                     });
                     
                 }
                 else if (compressionEncoder.status == AVAssetExportSessionStatusCancelled)
                 {
                     //                     HUD.labelText = @"Compression Failed";

                     [MBProgressHUD showError:@"取消合成"  toView:self.view];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         
                         
                         
                     });
                 }
                 else
                 {
                     [MBProgressHUD showError:@"合成失败"  toView:self.view];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         
                     });
                 }
             });
         }];
    }];
     */
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 告诉系统每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _filterAry.count;
    
}

// 告诉系统每个Cell如何显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MyCollectionCell";
    MusicItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    FilterData* data = [_filterAry objectAtIndex:indexPath.row];
    cell.iconImgView.image = [UIImage imageWithContentsOfFile:data.iconPath];
    cell.nameLabel.text = data.name;
    
    cell.CheckMarkImgView.hidden = !data.isSelected;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        _nowFilterIndex = indexPath;
        if (_lastFilterIndex.row != _nowFilterIndex.row) {
            
            //1.修改数据源
            FilterData* dataNow = [_filterAry objectAtIndex:indexPath.row];
            dataNow.isSelected = YES;
            [_filterAry replaceObjectAtIndex:indexPath.row withObject:dataNow];
            FilterData* dataLast = [_filterAry objectAtIndex:_lastFilterIndex.row];
            dataLast.isSelected = NO;
            [_filterAry replaceObjectAtIndex:_lastFilterIndex.row withObject:dataLast];
            //2.刷新collectionView
            [_collectionView reloadData];
            _lastFilterIndex = indexPath;
    
        }
        
        if (indexPath.row == 0) {
            [movieFile removeAllTargets];
            
            FilterData* data = [_filterAry objectAtIndex:indexPath.row];
            _filtClassName = data.fillterName;
            filter = [[NSClassFromString(_filtClassName) alloc] init];
            [movieFile addTarget:filter];
            [filter addTarget:_filterView];
            
        }else
        {
            [movieFile removeAllTargets];
            
            FilterData* data = [_filterAry objectAtIndex:indexPath.row];
            _filtClassName = data.fillterName;
            
            if ([data.fillterName isEqualToString:@"GPUImageSaturationFilter"]) {
                GPUImageSaturationFilter* xxxxfilter = [[NSClassFromString(_filtClassName) alloc] init];
                xxxxfilter.saturation = [data.value floatValue];
                _saturationValue = [data.value floatValue];
                filter = xxxxfilter;
                
            }else{
                filter = [[NSClassFromString(_filtClassName) alloc] init];
            }
            [movieFile addTarget:filter];
            
            // Only rotate the video for display, leave orientation the same for recording
            //            GPUImageView *filterView = (GPUImageView *)self.view;
            [filter addTarget:_filterView];
        }
        
    }
}


@end
