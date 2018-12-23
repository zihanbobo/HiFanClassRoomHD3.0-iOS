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
    
    
    //MARK:播放视频
    self.wmPlayer = [[WMPlayer alloc] init];
    self.wmPlayer.frame = CGRectMake(LineX(184), LineY(71), LineW(556), LineH(313));
    self.wmPlayer.backBtnStyle = BackBtnStyleNone;
//    self.wmPlayer.layer.masksToBounds = YES;
//    self.wmPlayer.layer.cornerRadius = 7;
    self.wmPlayer.delegate = self;
    [self addSubview:self.wmPlayer];
//    [self.superview addSubview:self.wmPlayer];

//    [[UIApplication sharedApplication] keyWindow]
//    [self.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(71);
//        make.left.equalTo(self.mas_left).with.offset(184);
//        make.right.equalTo(self.mas_right).with.offset(-184);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-71);
//    }];
    
}

//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (self.playerDelegate && [self.playerDelegate respondsToSelector:@selector(player:clickedFullScreenButton:)]) {
        [self.playerDelegate player:wmplayer clickedFullScreenButton:fullScreenBtn];
    }
    
}


- (void)setPlayerUrlStr:(NSString *)playerUrlStr {
    [self.wmPlayer resetWMPlayer];
    WMPlayerModel *playerModel = [WMPlayerModel new];
    playerModel.videoURL = [NSURL URLWithString:playerUrlStr];
    self.wmPlayer.playerModel = playerModel;
    [self.wmPlayer play];
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
