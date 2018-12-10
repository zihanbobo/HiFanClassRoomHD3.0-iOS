//
//  HF_OrderDateCell.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_OrderDateCell.h"

@implementation HF_OrderDateCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setCellUI];
    }
    return self;
}
- (void)setCellUI {
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = Font(14);
    self.dateLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.text = @"12月07日";
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6);
        make.width.mas_equalTo(65);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(20);
    }];
    self.weekLabel = [UILabel new];
    self.weekLabel.font = Font(14);
    self.weekLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    self.weekLabel.textAlignment = NSTextAlignmentCenter;
    self.weekLabel.text = @"星期四";
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(65);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(20);
    }];
}
@end
