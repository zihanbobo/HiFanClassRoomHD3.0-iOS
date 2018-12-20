//
//  HF_MyScheduleHomeUnFinishedCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/3.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MyScheduleHomeUnFinishedCell.h"


@interface HF_MyScheduleHomeUnFinishedCell()
//背景
@property (nonatomic, strong) UIView *bigContentView;
//上课时间
@property (nonatomic, strong) UILabel *startTimeLabel;
//取消课程
@property (nonatomic, strong) UIButton *cancleClassButton;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
//课前预习
@property (nonatomic,strong) UIButton *classBeforeButton;
//进入教室
@property (nonatomic,strong) UIButton *classEnterButton;
@end


@implementation HF_MyScheduleHomeUnFinishedCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark 初始化界面
- (void)initView {
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    //背景
    self.bigContentView = [[UIView alloc]init];
    self.bigContentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.contentView addSubview:self.bigContentView];
    
    [self.bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];

    
    
    //上课时间
    self.startTimeLabel = [[UILabel alloc]init];
    self.startTimeLabel.font = Font(14);
    self.startTimeLabel.text = @"08月23日 （周四）20:00";
    self.startTimeLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.bigContentView addSubview:self.startTimeLabel];
   
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(25);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.height.mas_equalTo(14);
    }];
    
    
    //取消课程
    self.cancleClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleClassButton setTitle:@"取消课程" forState:UIControlStateNormal];
    [self.cancleClassButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 40) forState:UIControlStateNormal];
    self.cancleClassButton.titleLabel.font = Font(14);
    [self.bigContentView addSubview:self.cancleClassButton];
    
    [self.cancleClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(27);
        make.right.equalTo(self.bigContentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(14);
    }];
    
    //上分割线
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.bigContentView addSubview:lineView1];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(56);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.right.equalTo(self.bigContentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(1);
    }];

    
    
    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = Font(20);
    self.classNameLabel.text = @"Delicious Food";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.bigContentView addSubview:self.classNameLabel];
    
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom).with.offset(36);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.height.mas_equalTo(20);
    }];
    
    
    //下分割线
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.bigContentView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classNameLabel.mas_bottom).with.offset(17);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.right.equalTo(self.bigContentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(1);
    }];
    
    
    //课前预习
    self.classBeforeButton = [UIButton new];
    self.classBeforeButton.titleLabel.font = Font(16);
    [self.classBeforeButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:UIControlStateNormal];
    [self.classBeforeButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
    [self.classBeforeButton setTitle:@"课前预习" forState:UIControlStateNormal];
    [self.bigContentView addSubview:self.classBeforeButton];
    
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigContentView.mas_left).offset(17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(117, 40));
    }];
    
    
    //进入教室
    self.classEnterButton = [UIButton new];
    self.classEnterButton.titleLabel.font = Font(16);
    [self.classEnterButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    [self.classEnterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterClassBtn") forState:UIControlStateNormal];
    [self.classEnterButton setTitle:@"进入教室" forState:UIControlStateNormal];
    [self.bigContentView addSubview:self.classEnterButton];
    
    
    [self.classEnterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bigContentView.mas_right).offset(-17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(117, 40));
    }];
}

- (void)drawRect:(CGRect)rect {
    [self.bigContentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
}


@end
