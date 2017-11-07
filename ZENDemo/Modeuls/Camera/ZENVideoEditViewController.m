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


@interface ZENVideoEditViewController ()

@property (nonatomic,strong) UIView *videoContrainerView;
@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@end

@implementation ZENVideoEditViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _videoContrainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _videoContrainerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_videoContrainerView];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_videoURL]];

    AVPlayer *tmpPlayer = [AVPlayer playerWithPlayerItem:item];
    self.player = tmpPlayer;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.videoContrainerView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.videoContrainerView.layer addSublayer:_playerLayer];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];

    [self.player play];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
