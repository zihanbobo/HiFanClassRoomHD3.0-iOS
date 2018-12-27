//
//  HF_TechnicalDebugView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/14.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_TechnicalDebugView.h"

@implementation HF_TechnicalDebugView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    //检测设备
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = Font(20);
    titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(20)];
    titleLabel.text = @"技术调试";
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(26);
        make.height.mas_offset(20);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.mas_top).offset(63);
        make.height.mas_offset(1);
    }];
    
    
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:UIIMAGE_FROM_NAME(@"close") forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    phoneLabel.text = @"客服电话：400-6767-671";
    phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(22)];
    [self addSubview:phoneLabel];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(lineView.mas_bottom).offset(50);
        make.height.mas_offset(22);
    }];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    contentLabel.text = @"周一～周日 08:00～22:00";
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(16)];
    [self addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(16);
    }];
    
    //去设置
    self.enterClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.enterClassButton setBackgroundImage:UIIMAGE_FROM_NAME(@"实心按钮") forState:UIControlStateNormal];
    [self.enterClassButton setTitle:@"在线技术支持" forState:UIControlStateNormal];
    [self.enterClassButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    self.enterClassButton.titleLabel.font = Font(18);
    [self addSubview:self.enterClassButton];
    
    [self.enterClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-25);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(321, 49));
    }];
    
}


@end
