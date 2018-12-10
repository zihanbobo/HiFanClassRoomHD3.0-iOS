//
//  HF_OrderTimeListView.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_OrderTimeListView.h"

@implementation HF_OrderTimeListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTimeListView];
    }
    return self;
}
- (void)initTimeListView {
    self.backgroundColor = UICOLOR_FROM_HEX(0xffffff);
    self.layer.cornerRadius = 7;
    [self addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:0.12 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX(0x000000)];
    UILabel *timeTitleLabel = [UILabel new];
    timeTitleLabel.font = Font(16);
    timeTitleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    timeTitleLabel.text = @"请选择开课时间";
    [self addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(25);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(16);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(527);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(timeTitleLabel.mas_bottom).offset(17);
    }];
    
    UIView *AM = [UIView new];
    [self addSubview:AM];
    [AM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(86);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    UIView *AMLine = [UIView new];
    AMLine.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
    [AM addSubview:AMLine];
    [AMLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(AM);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(AM.mas_bottom).offset(-2);
    }];
    
    UILabel *AMLabel = [UILabel new];
    AMLabel.font = Font(16);
    AMLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    AMLabel.text = @"早上";
    [AM addSubview:AMLabel];
    [AMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(AM.mas_centerX);
        make.centerY.equalTo(AM.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    
    
    
    UIView *PM = [UIView new];
    [self addSubview:PM];
    [PM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(202);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    UIView *PMLine = [UIView new];
    PMLine.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
    [PM addSubview:PMLine];
    [PMLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(PM);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(PM.mas_bottom).offset(-2);
    }];
    
    UILabel *PMLabel = [UILabel new];
    PMLabel.font = Font(16);
    PMLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    PMLabel.text = @"下午";
    [PM addSubview:PMLabel];
    [PMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(PM.mas_centerX);
        make.centerY.equalTo(PM.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    
    
    UIView *NIT = [UIView new];
    [self addSubview:NIT];
    [NIT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(318);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    UIView *NITLine = [UIView new];
    NITLine.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
    [NIT addSubview:NITLine];
    [NITLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(NIT);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(NIT.mas_bottom).offset(-2);
    }];
    
    UILabel *NITLabel = [UILabel new];
    NITLabel.font = Font(16);
    NITLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    NITLabel.text = @"晚上";
    [NIT addSubview:NITLabel];
    [NITLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(NIT.mas_centerX);
        make.centerY.equalTo(NIT.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
}
@end
