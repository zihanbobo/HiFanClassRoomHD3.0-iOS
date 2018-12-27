//
//  HF_HomeUnGradedContentCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/26.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnGradedContentCell.h"

@implementation HF_HomeUnGradedContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView {
    //未定级弹窗
    UIImageView *bgImgView = [[UIImageView alloc]init];
    bgImgView.image = UIIMAGE_FROM_NAME(@"未定级弹窗");
    [self.contentView addSubview:bgImgView];
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(50);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(370, 401));
    }];
    
    //二维码
    UIImageView *erweimaImgView = [[UIImageView alloc] init];
    erweimaImgView.image = UIIMAGE_FROM_NAME(@"微信二维码");
    [bgImgView addSubview:erweimaImgView];
    
    [erweimaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImgView.mas_centerX);
        make.top.equalTo(bgImgView.mas_top).offset(170);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.font = Font(13);
    label.numberOfLines = 0;
    label.text = @"微信扫码上方二维码，关注「hi翻外教课堂」服务号，\n关注后，请点击服务号下方的「预约上课」进行分级。";
    label.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [bgImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(erweimaImgView.mas_bottom).offset(10);
        make.centerX.equalTo(bgImgView.mas_centerX);
        make.height.mas_equalTo(40);
    }];
    
}

@end
