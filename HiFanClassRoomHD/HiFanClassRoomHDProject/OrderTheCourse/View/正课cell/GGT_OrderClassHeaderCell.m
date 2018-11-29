//
//  GGT_OrderClassHeaderCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderClassHeaderCell.h"

@interface GGT_OrderClassHeaderCell()
//背景图片
@property (nonatomic, strong) UIImageView *bgImgView;
//定级
@property (nonatomic, strong) UILabel *levelLabel;
//label1
@property (nonatomic, strong) UILabel *label1;
//label2
@property (nonatomic, strong) UILabel *label2;
@end


@implementation GGT_OrderClassHeaderCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark 初始化界面
- (void)initView {
    //背景图片
    self.bgImgView = [UIImageView new];
    self.bgImgView.layer.masksToBounds = YES;
    self.bgImgView.layer.cornerRadius = LineH(6);
    self.bgImgView.image = UIIMAGE_FROM_NAME(@"orderCourseBg");
    [self addSubview:self.bgImgView];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(LineY(10));
        make.left.equalTo(self.mas_left).with.offset(LineX(13));
        make.right.equalTo(self.mas_right).with.offset(-LineX(13));
        make.bottom.equalTo(self.mas_bottom).with.offset(-LineH(5));
    }];
    

    //定级
    UIView *levelView = [UIView new];
    levelView.layer.masksToBounds = YES;
    levelView.layer.cornerRadius = LineH(16);
    levelView.layer.borderWidth = LineW(1);
    levelView.layer.borderColor = UICOLOR_FROM_HEX(Color2B8EEF).CGColor;
    levelView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(43, 142, 239, 0.1);
    [self.bgImgView addSubview:levelView];
    
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_top).with.offset(LineX(21));
        make.centerX.equalTo(self.bgImgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(68), LineH(32)));
    }];
    
    
    self.levelLabel = [UILabel new];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.font = Font(20);
    self.levelLabel.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
    [levelView addSubview:self.levelLabel];

    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(levelView.mas_centerY);
        make.centerX.equalTo(levelView.mas_centerX);
        make.height.mas_equalTo(LineH(28));
    }];
  
    
    //label1
    self.label1 = [UILabel new];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.font = Font(16);
    self.label1.textColor = UICOLOR_FROM_HEX(0x9B9B9B);
    [self.bgImgView addSubview:self.label1];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelView.mas_bottom).with.offset(LineX(10));
        make.centerX.equalTo(self.bgImgView.mas_centerX);
        make.height.mas_equalTo(LineH(22));
    }];
    
    
    //label2
    self.label2 = [UILabel new];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.font = Font(18);
    self.label2.textColor = UICOLOR_FROM_HEX(0x4A4A4A);
    [self.bgImgView addSubview:self.label2];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label1.mas_bottom).with.offset(LineX(8));
        make.centerX.equalTo(self.bgImgView.mas_centerX);
        make.height.mas_equalTo(LineH(25));
    }];

}

-(void)getModel:(GGT_UnitBookListHeaderModel *)model {
    self.levelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    
    self.label1.text = [NSString stringWithFormat:@"%@",model.Introduction];
    
    self.label2.text = [NSString stringWithFormat:@"已完成%ld课，共%ld课",(long)model.UseCount,(long)model.TotalCount];
}



@end
