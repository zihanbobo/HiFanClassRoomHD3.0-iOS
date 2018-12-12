//
//  HF_MineClassCountListCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineClassCountListCell.h"

@interface HF_MineClassCountListCell()
@property (nonatomic, strong) UILabel *leftNameLabel;    //名称
@property (nonatomic, strong) UILabel *centerCountLabel; //扣减数量
@property (nonatomic, strong) UILabel *rightLabel;       //说明
@end

@implementation HF_MineClassCountListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}


- (void)initView {
    //名称
    self.leftNameLabel = [[UILabel alloc]init];
    self.leftNameLabel.font = Font(14);
    self.leftNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
//    self.leftNameLabel.text = @"我的课时";
    [self.contentView addSubview:self.leftNameLabel];
    
    [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(14);
    }];
    
    //扣减数量
    self.centerCountLabel = [[UILabel alloc]init];
    self.centerCountLabel.font = Font(14);
    self.centerCountLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
//    self.centerCountLabel.text = @"-1";
    [self.contentView addSubview:self.centerCountLabel];
    
    [self.centerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(14);
    }];
    
    
    //说明
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = Font(14);
    self.rightLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
//    self.rightLabel.text = @"2018-08-09";
    [self.contentView addSubview:self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(14);
    }];
    
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
        make.height.mas_offset(1);
    }];
    
}


- (void)setListModel:(HF_MineClassCountListModel *)listModel {
    if (!IsStrEmpty(listModel.TypeName)) {
        self.leftNameLabel.text = listModel.TypeName;
    }
    
    if (!IsStrEmpty(listModel.Hours)) {
        self.centerCountLabel.text = listModel.Hours;
    }
    
    if (!IsStrEmpty(listModel.CreateTime)) {
        self.rightLabel.text = listModel.CreateTime;
    }
    
}
@end
