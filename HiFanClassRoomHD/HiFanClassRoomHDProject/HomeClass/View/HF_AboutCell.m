//
//  HF_AboutCell.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_AboutCell.h"

@implementation HF_AboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initCellUI];
    }
    return self;
}
- (void)initCellUI
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangHK-Medium" size:LineX(15)];
    self.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(17);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(18);
    }];
    self.contentLabel = [UILabel new];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont fontWithName:@"PingFangHK-Regular" size:LineX(14)];
    self.contentLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-17);
        make.bottom.equalTo(self.mas_bottom).offset(-13);
    }];
    
}
-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
-(void)setContent:(NSString *)content
{
    self.contentLabel.text = content;
}
@end
