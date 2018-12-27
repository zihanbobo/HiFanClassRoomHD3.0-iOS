//
//  HF_FindMoreHomeCollectionViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreHomeCollectionViewCell.h"

@interface HF_FindMoreHomeCollectionViewCell()
//教材view
@property (nonatomic, strong) UIView *bookBgView;
//教材 封面
@property (nonatomic, strong) UIImageView *bookImgView;
//更新 多少 集
@property (nonatomic, strong) UILabel *numLabel;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
//课程 简介
@property (nonatomic, strong) UILabel *classInfoLabel;
@end

@implementation HF_FindMoreHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initView];
    }
    return self;
}

- (void)initView {
    //教材 封面
    self.bookBgView = [[UIView alloc] init];
    self.bookBgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.contentView addSubview:self.bookBgView];

    [self.bookBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(18);
        make.left.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(230, 180));
    }];
    
    
    self.bookImgView = [[UIImageView alloc]init];
    self.bookImgView.image = UIIMAGE_FROM_NAME(@"缺省图211-165");
    self.bookImgView.userInteractionEnabled = YES;
    self.bookImgView.clipsToBounds =YES;
    [self.bookBgView addSubview:self.bookImgView];
    
    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.bookBgView);
    }];

    //更新 多少 集
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.font = Font(12);
//    self.numLabel.text = @"更新至19集";
    self.numLabel.textColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.bookImgView addSubview:self.numLabel];
    
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bookImgView.mas_bottom).offset(-3);
        make.right.equalTo(self.bookImgView.mas_right).offset(-10);
        make.height.mas_equalTo(12);
    }];
    
    
    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = Font(16);
//    self.classNameLabel.text = @"字母世界 (更新至9集)";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.contentView addSubview:self.classNameLabel];
    
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookBgView.mas_bottom).with.offset(17);
        make.left.equalTo(self.bookBgView.mas_left);
        make.height.mas_equalTo(16);
    }];
    
    
    //课程 简介
    self.classInfoLabel = [[UILabel alloc]init];
    self.classInfoLabel.font = Font(12);
//    self.classInfoLabel.text = @"初试字母 快速入门";
    self.classInfoLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    [self.contentView addSubview:self.classInfoLabel];
    
    
    [self.classInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classNameLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.bookBgView.mas_left);
        make.height.mas_equalTo(12);
    }];
}


- (void)drawRect:(CGRect)rect {
    [self.bookBgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:7];
//    [self.bookBgView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
//    [self.bookImgView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];

    [self.bookBgView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
    [self.bookBgView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];
}


- (void)setModel:(HF_FindMoreInstructionalTypeListModel *)model {
    if (!IsStrEmpty(model.CoverImage)) {
        [self.bookImgView sd_setImageWithURL:[NSURL URLWithString:model.CoverImage] placeholderImage:UIIMAGE_FROM_NAME(@"缺省图211-165")];
    }
  
    
    NSString *numStr = [NSString stringWithFormat:@"更新至%ld集",(long)model.Count];
    if (!IsStrEmpty(numStr)) {
        self.numLabel.text = numStr;
    }
    
    
    if (!IsStrEmpty(model.Title)) {
        self.classNameLabel.text = model.Title;
    }

    
    if (!IsStrEmpty(model.SubTitle)) {
        self.classInfoLabel.text = model.SubTitle;
    }
}

@end
