//
//  HF_HomeUnitLastCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/21.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitLastCell.h"



@interface HF_HomeUnitLastCell()
@property (nonatomic,strong) HF_HomeUnitLastView *firstView;
@property (nonatomic,strong) HF_HomeUnitLastView *secondView;
@end

@implementation HF_HomeUnitLastCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.firstView = [[HF_HomeUnitLastView alloc] init];
    self.firstView.iconImgView.image = UIIMAGE_FROM_NAME(@"书法");
    self.firstView.titleLabel.text = @"课堂讲义下载";
    self.firstView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.contentView addSubview:self.firstView];
    
    
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-0);
        make.height.mas_equalTo(103);
    }];
    
    
    self.secondView = [[HF_HomeUnitLastView alloc] init];
    self.secondView.iconImgView.image = UIIMAGE_FROM_NAME(@"练习册");
    self.secondView.titleLabel.text = @"练习册下载";
    self.secondView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.contentView addSubview:self.secondView];
    
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-3);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-0);
        make.height.mas_equalTo(103);
    }];
}

- (void)drawRect:(CGRect)rect {
//    [self.firstView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
//    [self.firstView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];
//    [self.secondView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
//    [self.secondView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];
}

@end


//MARK:UIView
@interface HF_HomeUnitLastView()

@end

@implementation HF_HomeUnitLastView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:self.bgView];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-0);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
    }];
    
    
    
    self.iconImgView = [[UIImageView alloc] init];
    [self.bgView addSubview:self.iconImgView];
    
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(25);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    self.unitLabel = [[UILabel alloc] init];
    self.unitLabel.textColor = UICOLOR_FROM_HEX(0x02B6E3);
    self.unitLabel.font = Font(10);
    self.unitLabel.text = @"Unit2";
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0x67D3CE, 20);
    [self.bgView addSubview:self.unitLabel];
    
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(12);
        make.top.equalTo(self.bgView.mas_top).offset(32);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    self.titleLabel.font = Font(16);
    [self.bgView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(12);
        make.top.equalTo(self.unitLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
}

- (void)drawRect:(CGRect)rect {
    [self.bgView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
    [self.bgView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];
    [self.unitLabel addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(0x02B6E3) CornerRadius:7];
    [self.unitLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:7];
}

@end

