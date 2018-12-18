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
    //背景图片
    UIImageView *bgimgView = [[UIImageView alloc]init];
    bgimgView.image = UIIMAGE_FROM_NAME(@"圣诞背景");
    [self addSubview:bgimgView];
    
    
    [bgimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
    }];
    
    
    
    UIView *moviePlayerView = [[UIView alloc] init];
    moviePlayerView.backgroundColor = UICOLOR_RANDOM_COLOR();
    [self addSubview:moviePlayerView];
    
    [moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(71);
        make.left.equalTo(self.mas_left).with.offset(184);
        make.right.equalTo(self.mas_right).with.offset(-184);
        make.height.mas_equalTo(313);
    }];
    
    
    //MARK:导航分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.mas_equalTo(1);
    }];
}

@end
