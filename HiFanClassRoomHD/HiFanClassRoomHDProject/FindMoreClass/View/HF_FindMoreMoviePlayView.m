//
//  HF_FindMoreMoviePlayView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreMoviePlayView.h"

@interface HF_FindMoreMoviePlayView()
@property (nonatomic, strong) UIImageView *bgimgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) AVPlayer *avPlayer; //视频播放器

@end

@implementation HF_FindMoreMoviePlayView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}



-(void)initUI {
    [self addSubview:self.bgimgView];
    [self.bgimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.mas_equalTo(1);
    }];
    
    
    //初始化视频播放地址
    NSURL *mediaUrl = [NSURL URLWithString:@"http://o2mzy.gogo-talk.com/guanwang/videos/web_3.mp4"];
    // 初始化播放单元
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:mediaUrl];
    //初始化播放器对象
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    //显示画面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //视频填充模式
    layer.masksToBounds = YES;
    layer.cornerRadius = 7;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //设置画布frame
    layer.frame = CGRectMake(184, 71, home_right_width-368, 313);
    //添加到当前视图
    [self.avPlayer play];
    [self.layer addSublayer:layer];

    
//    [self addSubview:self.avPlayer];
//    [self.avPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(71);
//        make.left.equalTo(self.mas_left).with.offset(184);
//        make.right.equalTo(self.mas_right).with.offset(-184);
//        make.height.mas_equalTo(313);
//    }];
}

//视频播放器
- (AVPlayer *)avPlayer {
    if (_avPlayer == nil) {
        self.avPlayer = [[AVPlayer alloc] init];
        self.avPlayer.volume = 1.0; // 默认最大音量
    }
    return _avPlayer;
}


//背景图片
-(UIImageView *)bgimgView {
    if (!_bgimgView) {
        self.bgimgView = [[UIImageView alloc]init];
        self.bgimgView.image = UIIMAGE_FROM_NAME(@"圣诞背景");
    }
    return _bgimgView;
}

//导航分割线
-(UIView *)lineView {
    if (!_lineView) {
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    }
    return _lineView;
}
@end
