//
//  HF_OrderTimeCell.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_OrderTimeCell.h"

@implementation HF_OrderTimeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTimeCell];
    }
    return self;
}
- (void)setTimeCell {
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = Font(16);
    self.timeLabel.text = @"18:30";
    self.timeLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
@end
