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
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    [self getBaseRequestURL];
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.finishedBlock) {
            self.finishedBlock();
        }
    });
}

// 获取BaseURL
- (void)getBaseRequestURL {
    
    HF_Singleton *single = [HF_Singleton sharedSingleton];
    single.base_url = BASE_REQUEST_URL;
    single.isAuditStatus = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@?Version=v%@", URL_GetUrl, APP_VERSION()];
    [[BaseService share] sendGetRequestWithPath:url token:NO viewController:nil showMBProgress:NO success:^(id responseObject) {
        
        // 逻辑后台处理
        dispatch_async(dispatch_get_main_queue(), ^{
            single.base_url = responseObject[@"data"];
            //如果地址一样则为正式地址，为非审核状态，为NO。否则为测试地址，为YES
            if ([single.base_url isEqualToString:BASE_REQUEST_URL]) {
                
                single.isAuditStatus = NO;
                
                //用户未登录，需要设置为NO
                if (![[UserDefaults() objectForKey:@"login"] isEqualToString:@"yes"]) {
                    single.isShowVersionUpdateAlert = NO;
                } else {
                    single.isShowVersionUpdateAlert = YES;
                }
                
            } else {
                
                single.isAuditStatus = YES;
            }
            
        });
        
    } failure:^(NSError *error) {
        
        single.base_url = BASE_REQUEST_URL;
        
        // 暂时开启测试地址
        //        NSString *url = [NSString stringWithFormat:@"%@:9332", BASE_REQUEST_URL];
        //        single.base_url = url;
        single.isAuditStatus = NO;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
