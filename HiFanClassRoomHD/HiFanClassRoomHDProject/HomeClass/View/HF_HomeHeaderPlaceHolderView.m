//
//  HF_HomeHeaderPlaceHolderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/26.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeHeaderPlaceHolderView.h"


@interface HF_HomeHeaderPlaceHolderView()
@end


@implementation HF_HomeHeaderPlaceHolderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initUI];
    }
    return self;
}

-(void)initUI {
    UIImageView *placeHolderimgView = [[UIImageView alloc] init];
    placeHolderimgView.image = UIIMAGE_FROM_NAME(@"约课空数据");
    [self addSubview:placeHolderimgView];
    
    [placeHolderimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(43);
        make.left.equalTo(self.mas_left).offset(17);
        make.size.mas_equalTo(CGSizeMake(265, 152));
    }];
    
    
    //上面的
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = UIIMAGE_FROM_NAME(@"对话框1");
    [self addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(310);
        make.size.mas_equalTo(CGSizeMake(332, 113));
    }];
    

    UILabel *label1 = [[UILabel alloc]init];
    label1.font = Font(18);
    label1.text = @"您还未预约课程哦~";
    label1.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [topImgView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_top).offset(37);
        make.left.equalTo(topImgView.mas_left).offset(50);
        make.height.mas_equalTo(18);
    }];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = Font(14);
    label2.text = @"扫描下方微信二维码，立即约课吧！";
    label2.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [topImgView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(7);
        make.left.equalTo(topImgView.mas_left).offset(50);
        make.height.mas_equalTo(14);
    }];
    
    
    //下面的
    UIImageView *bottomImgView = [[UIImageView alloc] init];
    bottomImgView.image = UIIMAGE_FROM_NAME(@"对话框2");
    [self addSubview:bottomImgView];
    
    [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(110);
        make.left.equalTo(self.mas_left).offset(310);
        make.size.mas_equalTo(CGSizeMake(160, 141));
    }];
    
    UIImageView *erweimaImgView = [[UIImageView alloc] init];
    erweimaImgView.image = UIIMAGE_FROM_NAME(@"timg");
    [bottomImgView addSubview:erweimaImgView];
    
    [erweimaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomImgView.mas_centerY);
        make.right.equalTo(bottomImgView.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(84, 84));
    }];
    
    
}


@end
