//
//  HF_FindMoreMoviePlayView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreMoviePlayView.h"

@implementation HF_FindMoreMoviePlayView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}

-(void)initUI {
    UIView *moviePlayerView = [[UIView alloc] init];
    moviePlayerView.backgroundColor = UICOLOR_RANDOM_COLOR();
    [self addSubview:moviePlayerView];
    
    [moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(25);
        make.left.equalTo(self.mas_left).with.offset(133);
        make.right.equalTo(self.mas_right).with.offset(-133);
        make.height.mas_equalTo(370);
    }];
    
    //课程名称
    UILabel *moviePlayerViewNameLabel = [[UILabel alloc]init];
    moviePlayerViewNameLabel.font = Font(18);
    moviePlayerViewNameLabel.text = @"Phonics - R Blends";
    moviePlayerViewNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self addSubview:moviePlayerViewNameLabel];
    
    
    [moviePlayerViewNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerView.mas_bottom).with.offset(17);
        make.left.equalTo(moviePlayerView.mas_left);
        make.height.mas_equalTo(18);
    }];
    
    
    //MARK:分享
    UIButton *shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shareButton setTitleColor:UICOLOR_FROM_HEX(Color000000) forState:UIControlStateNormal];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setImage:UIIMAGE_FROM_NAME(@"爱心") forState:(UIControlStateNormal)];
    shareButton.titleLabel.font = Font(16);
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(2.5), 0, 0);
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(2.5));
    [self addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerView.mas_bottom).with.offset(17);
        make.right.equalTo(moviePlayerView.mas_right);
        make.height.mas_equalTo(16);
    }];
    
    
    //MARK:喜欢
    UIButton *collectionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [collectionButton setTitleColor:UICOLOR_FROM_HEX(Color000000) forState:UIControlStateNormal];
    [collectionButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [collectionButton setImage:UIIMAGE_FROM_NAME(@"爱心") forState:(UIControlStateNormal)];
    collectionButton.titleLabel.font = Font(16);
    collectionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(2.5), 0, 0);
    collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(2.5));
    [self addSubview:collectionButton];
    
    [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerView.mas_bottom).offset(17);
        make.right.equalTo(shareButton.mas_left).offset(-20);
        make.height.mas_equalTo(16);
    }];
    
    //MARK:导航分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerViewNameLabel.mas_bottom).offset(25);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.mas_equalTo(1);
    }];
}

@end
