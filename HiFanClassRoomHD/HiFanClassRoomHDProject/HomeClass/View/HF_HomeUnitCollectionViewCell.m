//
//  HF_HomeUnitCollectionViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitCollectionViewCell.h"

@interface HF_HomeUnitCollectionViewCell()
//背景
@property (nonatomic, strong) UIView *bigContentView;
//教材 封面
@property (nonatomic, strong) UIImageView *bookImgView;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
//状态
@property (nonatomic, strong) UILabel *classStatusLabel;
@end


@implementation HF_HomeUnitCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initView];
    }
    return self;
}

- (void)initView {
    //背景
    self.bigContentView = [[UIView alloc]init];
    self.bigContentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.contentView addSubview:self.bigContentView];
    
    [self.bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    
    //教材 封面
    self.bookImgView = [[UIImageView alloc]init];
    self.bookImgView.image = UIIMAGE_FROM_NAME(@"默认");
    self.bookImgView.userInteractionEnabled = YES;
    [self.bigContentView addSubview:self.bookImgView];

    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(0);
        make.left.right.equalTo(self.bigContentView);
        make.size.mas_equalTo(CGSizeMake(159, 158));
    }];


    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = Font(15);
        self.classNameLabel.text = @"Lesson2-1";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self.bigContentView addSubview:self.classNameLabel];


    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookImgView.mas_bottom).offset(17);
        make.left.equalTo(self.bigContentView.mas_left).offset(17);
        make.height.mas_equalTo(15);
    }];


    //课程 简介
    self.classStatusLabel = [[UILabel alloc]init];
    self.classStatusLabel.font = Font(11);
    self.classStatusLabel.text = @"已完成";
    self.classStatusLabel.textColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.bigContentView addSubview:self.classStatusLabel];


    [self.classStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classNameLabel.mas_centerY);
        make.left.equalTo(self.classNameLabel.mas_right).offset(7);
        make.height.mas_equalTo(12);
    }];
}

- (void)drawRect:(CGRect)rect {
//    [self.bookImgView xc_SetCornerWithSideType:XCSideTypeTopLine cornerRadius:7];
    [self.bigContentView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
    [self.bigContentView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];
}



@end