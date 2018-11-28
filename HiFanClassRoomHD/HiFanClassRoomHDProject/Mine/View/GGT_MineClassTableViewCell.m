//
//  GGT_MineClassTableViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/16.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineClassTableViewCell.h"

@implementation GGT_MineClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}

- (void)initView {
    self.leftTitleLabel = [[UILabel alloc]init];
    self.leftTitleLabel.font = Font(18);
    self.leftTitleLabel.textColor = UICOLOR_FROM_HEX(Color3D3D3D);
    self.leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.leftTitleLabel];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(LineX(20));
        make.right.equalTo(self.contentView.mas_centerX).offset(-LineX(30));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(LineH(25));
    }];
    
    
    
    self.centerTitleLabel = [[UILabel alloc]init];
    self.centerTitleLabel.font = Font(18);
    self.centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.centerTitleLabel.textColor = UICOLOR_FROM_HEX(Color3D3D3D);
    [self.contentView addSubview:self.centerTitleLabel];
    
    [self.centerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLabel.mas_right).offset(LineX(10));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(80), LineH(25)));
    }];
    
  
    
    
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    self.contentLabel.font = Font(16);
    [self.contentView addSubview:self.contentLabel];

    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerTitleLabel.mas_right).offset(LineX(10));
        make.right.equalTo(self.contentView.mas_right).offset(-LineX(21));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(LineH(22));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.mas_offset(LineH(1));
    }];
    
}


@end
