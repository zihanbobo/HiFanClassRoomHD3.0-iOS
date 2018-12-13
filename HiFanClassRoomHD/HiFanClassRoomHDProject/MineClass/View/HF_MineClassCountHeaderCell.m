//
//  HF_MineClassCountHeaderCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineClassCountHeaderCell.h"

@interface HF_MineClassCountHeaderCell()
@property (nonatomic, strong) UILabel *totalClassHoursLabel;    //总课时
@property (nonatomic, strong) UILabel *RemainingClassHoursLabel;//剩余课时
@property (nonatomic, strong) UILabel *outTimeLabel;            //有效期
@end


@implementation HF_MineClassCountHeaderCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView {
    //总课时
    self.totalClassHoursLabel = [[UILabel alloc]init];
    self.totalClassHoursLabel.font = Font(16);
    self.totalClassHoursLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
//    self.totalClassHoursLabel.text = @"总课时：5106";
    [self addSubview:self.totalClassHoursLabel];
    
    [self.totalClassHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(50);
        make.height.mas_offset(16);
    }];
    
    //剩余课时
    self.RemainingClassHoursLabel = [[UILabel alloc]init];
    self.RemainingClassHoursLabel.font = Font(16);
    self.RemainingClassHoursLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
//    self.RemainingClassHoursLabel.text = @"剩余课时：5088";
    [self addSubview:self.RemainingClassHoursLabel];
    
    [self.RemainingClassHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.totalClassHoursLabel.mas_bottom).offset(5);
        make.height.mas_offset(16);
    }];
    
    
    //有效期
    self.outTimeLabel = [[UILabel alloc]init];
    self.outTimeLabel.font = Font(12);
    self.outTimeLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
//    self.outTimeLabel.text = @"（有效期至：2019-12-09）";
    [self addSubview:self.outTimeLabel];
    
    [self.outTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RemainingClassHoursLabel.mas_right).offset(5);
        make.bottom.equalTo(self.RemainingClassHoursLabel.mas_bottom);
        make.height.mas_offset(12);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
        make.height.mas_offset(1);
    }];
    
}


- (void)setListHeaderModel:(HF_MineClassCountHeaderModel *)listHeaderModel {
    self.totalClassHoursLabel.text = [NSString stringWithFormat:@"总课时:%ld",(long)listHeaderModel.TotalCount] ;
    self.RemainingClassHoursLabel.text = [NSString stringWithFormat:@"剩余课时:%ld",(long)listHeaderModel.SurplusCount] ;

    if (!IsStrEmpty(listHeaderModel.ExpireTime)) {
        self.outTimeLabel.text = [NSString stringWithFormat:@"（有效期至:%@）",listHeaderModel.ExpireTime];;
    }
}

@end
