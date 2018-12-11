//
//  HF_MineClassCountHeaderCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineClassCountHeaderCell.h"

@interface HF_MineClassCountHeaderCell()
@property (nonatomic, strong) UIButton *leftButton;             //返回按钮
@property (nonatomic, strong) UILabel *totalClassHoursLabel;    //总课时
@property (nonatomic, strong) UILabel *RemainingClassHoursLabel;//剩余课时
@property (nonatomic, strong) UILabel *outTimeLabel;            //有效期
@end


@implementation HF_MineClassCountHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView {
    //返回按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:UIIMAGE_FROM_NAME(@"箭头") forState:UIControlStateNormal];
    [self.leftButton setImage:UIIMAGE_FROM_NAME(@"箭头") forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.leftButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    //我的课时
    UILabel *myCountLabel = [[UILabel alloc]init];
    myCountLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
    myCountLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    myCountLabel.text = @"我的课时";
    [self.contentView addSubview:myCountLabel];
    
    [myCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.leftButton.mas_bottom).offset(24);
        make.height.mas_offset(38);
    }];
    
    
    //总课时
    self.totalClassHoursLabel = [[UILabel alloc]init];
    self.totalClassHoursLabel.font = Font(16);
    self.totalClassHoursLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    self.totalClassHoursLabel.text = @"总课时：5106";
    [self.contentView addSubview:self.totalClassHoursLabel];
    
    [self.totalClassHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(myCountLabel.mas_bottom).offset(50);
        make.height.mas_offset(16);
    }];
    
    //剩余课时
    self.RemainingClassHoursLabel = [[UILabel alloc]init];
    self.RemainingClassHoursLabel.font = Font(16);
    self.RemainingClassHoursLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    self.RemainingClassHoursLabel.text = @"剩余课时：5088";
    [self.contentView addSubview:self.RemainingClassHoursLabel];
    
    [self.RemainingClassHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.totalClassHoursLabel.mas_bottom).offset(5);
        make.height.mas_offset(16);
    }];
    
    
    //有效期
    self.outTimeLabel = [[UILabel alloc]init];
    self.outTimeLabel.font = Font(12);
    self.outTimeLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    self.outTimeLabel.text = @"（有效期至：2019-12-09）";
    [self.contentView addSubview:self.outTimeLabel];
    
    [self.outTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RemainingClassHoursLabel.mas_right).offset(5);
        make.bottom.equalTo(self.RemainingClassHoursLabel.mas_bottom);
        make.height.mas_offset(12);
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

@end
