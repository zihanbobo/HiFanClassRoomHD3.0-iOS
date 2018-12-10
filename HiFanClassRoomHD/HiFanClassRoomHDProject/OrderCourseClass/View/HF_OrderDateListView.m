//
//  HF_OrderDateListView.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_OrderDateListView.h"

@implementation HF_OrderDateListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDateListView];
    }
    return self;
}
- (void)initDateListView {
    self.backgroundColor = UICOLOR_FROM_HEX(0xffffff);
    self.layer.cornerRadius = 7;
    [self addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:0.12 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX(0x000000)];
    UILabel *dateTitleLabel = [UILabel new];
    dateTitleLabel.font = Font(16);
    dateTitleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    dateTitleLabel.text = @"请选择上课日期";
    [self addSubview:dateTitleLabel];
    [dateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(25);
        make.left.equalTo(self.mas_left).offset(17);
        make.width.mas_equalTo(118);
        make.height.mas_equalTo(16);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(278);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(dateTitleLabel.mas_bottom).offset(17);
    }];
}
@end
