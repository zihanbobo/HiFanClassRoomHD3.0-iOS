//
//  HF_MineHomeHeaderCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineHomeHeaderCell.h"

@interface HF_MineHomeHeaderCell()
@property (nonatomic, strong) UIButton *leftButton;   //返回按钮
@property (nonatomic, strong) UILabel *nickNameLabel; //英文昵称
@property (nonatomic, strong) UILabel *ageLabel;      //年龄
@property (nonatomic, strong) UILabel *levelTitleLabel;  //级别标题
@property (nonatomic, strong) UILabel *levelLabel;    //级别
@property (nonatomic, strong) UIImageView *genderImageView;  //性别图标
@end

@implementation HF_MineHomeHeaderCell

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
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    @weakify(self);
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.backBlock) {
             self.backBlock();
         }
     }];
    
    //英文昵称
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
    self.nickNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
//    self.nickNameLabel.text = @"MIKE";
    [self.contentView addSubview:self.nickNameLabel];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.leftButton.mas_bottom).offset(0);
        make.height.mas_offset(42);
    }];
    
    //性别图标
    self.genderImageView = [UIImageView new];
    [self.contentView addSubview:self.genderImageView];
    [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(6);
        make.bottom.equalTo(self.nickNameLabel.mas_bottom).offset(-4);
    }];
    
     //年龄
    self.ageLabel = [[UILabel alloc]init];
    self.ageLabel.font = Font(18);
    self.ageLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
//    self.ageLabel.text = @"年龄：5岁";
    [self.contentView addSubview:self.ageLabel];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(15);
        make.height.mas_offset(18);
    }];


    //级别
    self.levelTitleLabel = [[UILabel alloc]init];
    self.levelTitleLabel.font = Font(18);
    self.levelTitleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    self.levelTitleLabel.text = @"级别：";
    [self.contentView addSubview:self.levelTitleLabel];
    
    [self.levelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLabel.mas_left).offset(0);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(5);
        make.height.mas_offset(18);
    }];
    
    //等级
    self.levelLabel = [UILabel new];
    self.levelLabel.font = Font(12);
    self.levelLabel.textColor = UICOLOR_FROM_HEX(Color02B6E3);
    self.levelLabel.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0x67D3CE, 20);
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.levelLabel];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.levelTitleLabel.mas_right).offset(0);
        make.centerY.equalTo(self.levelTitleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(35, 18));
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

-(void)setCellModel:(HF_MineHomeInfoModel *)cellModel {
    if (!IsStrEmpty(cellModel.EName)) {
      self.nickNameLabel.text = cellModel.EName;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"年龄：%ld岁",cellModel.Age];
    
    if (!IsStrEmpty(cellModel.Name)) {
        self.levelLabel.text = [NSString stringWithFormat:@"%@",@"A9"];
    }
    
    if(cellModel.Gender == 1){
        [self.genderImageView setImage:[UIImage imageNamed:@"男"]];
    }else if(cellModel.Gender == 2){
        [self.genderImageView setImage:[UIImage imageNamed:@"女"]];
    }
}


- (void)drawRect:(CGRect)rect {
    [self.levelLabel addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(Color67D3CE) CornerRadius:9];
    [self.levelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:9];
}

@end
