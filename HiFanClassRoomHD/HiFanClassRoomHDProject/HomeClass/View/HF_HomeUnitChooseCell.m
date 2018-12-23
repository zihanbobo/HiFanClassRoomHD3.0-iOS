//
//  HF_HomeUnitChooseCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitChooseCell.h"

@interface HF_HomeUnitChooseCell()
//状态
@property (nonatomic, strong) UIImageView *statusImgView;
@end

@implementation HF_HomeUnitChooseCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
        [self initView];
    }
    return self;
}

- (void)initView {
    //文字
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineW(18)];
    self.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];
    
    
    //状态
    self.statusImgView = [[UIImageView alloc] init];
    self.statusImgView.image = UIIMAGE_FROM_NAME(@"完成");
    [self.contentView addSubview:self.statusImgView];
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}


- (void)setCellModel:(HF_HomeGetUnitInfoListModel *)cellModel {
    NSString *nameStr = [NSString stringWithFormat:@"%@",cellModel.UnitName];
    if (!IsStrEmpty(nameStr)) {
        self.titleLabel.text = nameStr;
    }
}

@end
