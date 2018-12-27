//
//  HF_LaunchMovieViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/27.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_LaunchMovieViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HF_LaunchMovieViewController ()
@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）
@end

@implementation HF_LaunchMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //本地视频路径
    NSString* localFilePath = [[NSBundle mainBundle] pathForResource:@"iPad启动视频" ofType:@"mp4"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    //构建播放单元
    self.item = [AVPlayerItem playerItemWithURL:localVideoUrl];
    //构建播放器对象
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    //构建播放器的layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT());
    [self.view.layer addSublayer:self.playerLayer];
    [self.myPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
