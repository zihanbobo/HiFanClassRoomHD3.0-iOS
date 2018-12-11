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
    UIView *orderClassView = [UIView new];
    orderClassView.backgroundColor = [UIColor whiteColor];
    [self addSubview:orderClassView];
    [orderClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    orderClassView.layer.cornerRadius = 7;
    //[orderClassView xc_SetCornerWithSideType:6|7 cornerRadius:7];
    
    UIView *orderClassLine = [UIView new];
    orderClassLine.backgroundColor = UICOLOR_FROM_HEX(0xffffff);
//
    orderClassLine.layer.shadowColor = [UIColor blackColor].CGColor;
    orderClassLine.layer.shadowOpacity = 0.12;
    orderClassLine.layer.shadowRadius = 2;
    orderClassLine.layer.shadowOffset = CGSizeMake(0, -3);
    [self addSubview:orderClassLine];
    [orderClassLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-60);
        make.height.mas_equalTo(2);
    }];
    //[orderClassLine addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:0.12 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX(0x000000)];
    UILabel *selectTitle = [UILabel new];
    selectTitle.font = Font(12);
    [selectTitle sizeToFit];
    selectTitle.text = @"您已选择：";
    selectTitle.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 40);
    [orderClassView addSubview:selectTitle];
    [selectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderClassView.mas_centerY).offset(-3);
        make.left.equalTo(orderClassView.mas_left).offset(17);
    }];
    self.selectDateAndTime = [UILabel new];
    self.selectDateAndTime.font = Font(16);
    self.selectDateAndTime.textColor = UICOLOR_FROM_HEX(0x000000);
    self.selectDateAndTime.text = @"12月07日 18:30";
    [self.selectDateAndTime sizeToFit];
    [orderClassView addSubview:self.selectDateAndTime];
    [self.selectDateAndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectTitle.mas_right).offset(0);
        make.centerY.equalTo(selectTitle.mas_centerY);
    }];
    self.orderClassButton = [UIButton new];
    self.orderClassButton.backgroundColor = UICOLOR_FROM_HEX(0x02B6E3);
    [self.orderClassButton setTitle:@"确定预约" forState:UIControlStateNormal];
    [self.orderClassButton setTitleColor:UICOLOR_FROM_HEX(0xffffff) forState:UIControlStateNormal];
    [orderClassView addSubview:self.orderClassButton];
    [self.orderClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(198);
        //make.height.mas_equalTo(60);
        make.top.equalTo(orderClassView.mas_top).offset(0);
        make.bottom.equalTo(orderClassView.mas_bottom).offset(0);
        //make.centerY.equalTo(orderClassView.mas_centerY);
        make.right.equalTo(orderClassView.mas_right).offset(0);
    }];
}
@end
