//
//  LFBPlayViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBPlayViewController.h"
#import <AVKit/AVKit.h>

#define KScreenRate (375 / KMainW)
#define KSuitFloat(float) ((float) / KScreenRate)
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
@interface LFBPlayViewController ()
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation LFBPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.fileName;
    [self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)initUI
{
    // 进度条
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, KSuitFloat(400), KMainW - 100, 50)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    // 创建播放器
    _player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_model.localPath]]];
    
    // 创建显示的图层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, KMainW, 400);
    [self.view.layer addSublayer:playerLayer];
    
    // 播放视频
    [_player play];
    
    // 进度回调
    @weakify(self);
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        // 刷新slider
        slider.value = CMTimeGetSeconds(time) / CMTimeGetSeconds(self.player.currentItem.duration);
    }];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    // 计算时间
    float time = slider.value * CMTimeGetSeconds(_player.currentItem.duration);
    
    // 跳转到指定时间
    [_player seekToTime:CMTimeMake(time, 1.0)];
}

@end
