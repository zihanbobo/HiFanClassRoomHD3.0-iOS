//
//  GGT_MineHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineHeaderView.h"

@interface GGT_MineHeaderView()
//头像
@property (nonatomic, strong) UIImageView *headImgView;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
//累计上课
@property (nonatomic, strong) UILabel *classNumberLabel;
@end


@implementation GGT_MineHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    //头像
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.image = UIIMAGE_FROM_NAME(@"me_default_avatar");
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = LineW(40);
    self.headImgView.layer.borderWidth = LineW(2);
    self.headImgView.layer.borderColor = UICOLOR_FROM_HEX(Color2B8EEF).CGColor;
    [self addSubview:self.headImgView];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(40);
    }];
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = Font(20);
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.headImgView.mas_bottom).offset(10);
    }];
    
    
    //累计上课次数
    self.classNumberLabel = [UILabel new];
    self.classNumberLabel.font = Font(12);
    self.classNumberLabel.textColor = UICOLOR_FROM_HEX(Color232323);
    [self addSubview:self.classNumberLabel];
    
    [self.classNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
    
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_offset(1);
    }];
    
    
}

- (void)getResultModel:(GGT_MineLeftModel *)model {
    //头像 Gender 0女 girl  1男 boy
    if (model.Gender == 0) {
        if (IsStrEmpty(model.HeadImg)) {
            self.headImgView.image = UIIMAGE_FROM_NAME(@"girl");
        } else {
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImg]] placeholderImage:UIIMAGE_FROM_NAME(@"girl")];
        }
    } else {
        if (IsStrEmpty(model.HeadImg)) {
            self.headImgView.image = UIIMAGE_FROM_NAME(@"boy");
        } else {
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImg]] placeholderImage:UIIMAGE_FROM_NAME(@"boy")];
        }
    }
    
    
    
    //姓名
    if ([model.EName isKindOfClass:[NSString class]] && model.EName.length >0) {
        self.nameLabel.text = model.EName;
    } else {
        self.nameLabel.text = @"";
    }
    
    
    
    //累计上课次数
    NSString *str = [NSString stringWithFormat:@"累计上课 %ld 次",(long)model.AccumulateCount];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    //改变数字大小颜色
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:22.0]
                          range:NSMakeRange(5, str.length - 7)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:UICOLOR_FROM_HEX(Color2B8EEF)
                          range:NSMakeRange(5, str.length - 7)];
    //改变  次  的大小颜色
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:UICOLOR_FROM_HEX(0x7777777)
                          range:NSMakeRange(str.length-1, 1)];
    self.classNumberLabel.attributedText = AttributedStr;
    
}

@end
