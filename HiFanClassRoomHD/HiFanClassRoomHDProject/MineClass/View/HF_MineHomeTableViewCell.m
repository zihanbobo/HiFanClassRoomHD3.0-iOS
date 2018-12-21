//
//  HF_MineHomeTableViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineHomeTableViewCell.h"

@interface HF_MineHomeTableViewCell()
@property (nonatomic, strong) UILabel *leftNameLabel; //名称
@end

@implementation HF_MineHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}


- (void)initView {
    //名称
    self.leftNameLabel = [[UILabel alloc]init];
    self.leftNameLabel.font = Font(16);
    self.leftNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
//    self.leftNameLabel.text = @"我的课时";
    [self.contentView addSubview:self.leftNameLabel];
    
    [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(16);
    }];
    
    
    self.enterImgView = [[UIImageView alloc]init];
    self.enterImgView.contentMode = UIViewContentModeCenter;
    self.enterImgView.image = UIIMAGE_FROM_NAME(@"jinru_wode_liebiao");
    [self.contentView addSubview:self.enterImgView];
    
    [self.enterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(7, 12));
    }];
    
    //说明
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = Font(16);
    self.rightLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
//    self.rightLabel.text = @"我的课时";
    [self.contentView addSubview:self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.enterImgView.mas_left).offset(-11);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(16);
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

-(void)setLeftLabelString:(NSString *)leftLabelString {
    self.leftNameLabel.text = leftLabelString;
}


@end
