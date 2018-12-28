//
//  HF_MyScheduleHomeFinishedCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MyScheduleHomeFinishedCell.h"

@interface HF_MyScheduleHomeFinishedCell()
//背景
@property (nonatomic, strong) UIView *bigContentView;
//上课时间
@property (nonatomic, strong) UILabel *startTimeLabel;
//待评价
@property (nonatomic, strong) UIButton *pingjiaButton;
//教材封面
@property (nonatomic, strong) UIImageView *jiaocaiImgView;
//课程等级
@property (nonatomic, strong) UILabel *levelLabel;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
//课前预习
@property (nonatomic,strong) UIButton *classBeforeButton;
//课后练习
@property (nonatomic,strong) UIButton *classAfterButton;
@end


@implementation HF_MyScheduleHomeFinishedCell

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
//    self.startTimeLabel.text = @"08月23日 （周四）20:00";
    self.startTimeLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.bigContentView addSubview:self.startTimeLabel];
    
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(25);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.height.mas_equalTo(14);
    }];
    
    
    //待评价
    self.pingjiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pingjiaButton setTitle:@"待评价" forState:UIControlStateNormal];
    [self.pingjiaButton setTitleColor:UICOLOR_FROM_HEX(ColorFB9901) forState:UIControlStateNormal];
    self.pingjiaButton.titleLabel.font = Font(14);
    self.pingjiaButton.tag = 10;
    [self.bigContentView addSubview:self.pingjiaButton];
    
    [self.pingjiaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(27);
        make.right.equalTo(self.bigContentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(14);
    }];
    

    @weakify(self);
    [[self.pingjiaButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.practiceButtonBlock) {
             self.practiceButtonBlock(self.pingjiaButton);
         }
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
    
    
    //教材封面
    self.jiaocaiImgView = [[UIImageView alloc]init];
    self.jiaocaiImgView.image = UIIMAGE_FROM_NAME(@"默认");
    [self.bigContentView addSubview:self.jiaocaiImgView];
    
    
    [self.jiaocaiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom).with.offset(17);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.right.equalTo(self.bigContentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(187);
    }];

    
    //课程等级
    self.levelLabel = [[UILabel alloc]init];
    self.levelLabel.font = Font(12);
//    self.levelLabel.text = @"A0  Stage1";
    self.levelLabel.textColor = UICOLOR_FROM_HEX(Color02B6E3);
    [self.bigContentView addSubview:self.levelLabel];
    
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jiaocaiImgView.mas_bottom).with.offset(17);
        make.left.equalTo(self.bigContentView.mas_left).with.offset(17);
        make.height.mas_equalTo(14);
    }];
    
    
    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = Font(20);
//    self.classNameLabel.text = @"Delicious Food";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.bigContentView addSubview:self.classNameLabel];
    
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelLabel.mas_bottom).with.offset(5);
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
    self.classBeforeButton.tag = 11;
    [self.bigContentView addSubview:self.classBeforeButton];
    
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigContentView.mas_left).offset(17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(117, 40));
    }];
    
    
    [[self.classBeforeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.practiceButtonBlock) {
             self.practiceButtonBlock(self.classBeforeButton);
         }
     }];
    
    
    //课后练习
    self.classAfterButton = [UIButton new];
    self.classAfterButton.titleLabel.font = Font(16);
    [self.classAfterButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:UIControlStateNormal];
    [self.classAfterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
    [self.classAfterButton setTitle:@"课后练习" forState:UIControlStateNormal];
    self.classAfterButton.tag = 12;
    [self.bigContentView addSubview:self.classAfterButton];
    
    
    [self.classAfterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bigContentView.mas_right).offset(-17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(117, 40));
    }];
    
    [[self.classAfterButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.practiceButtonBlock) {
             self.practiceButtonBlock(self.classAfterButton);
         }
     }];
}

- (void)drawRect:(CGRect)rect {
    [self.bigContentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.jiaocaiImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(2)];
}


- (void)setListModel:(HF_MyScheduleHomeFinishedListModel *)listModel {
    if (!IsStrEmpty(listModel.FilePath)) {
        [self.jiaocaiImgView sd_setImageWithURL:[NSURL URLWithString:listModel.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(250), LineW(187))];
            self.jiaocaiImgView.image = image;
        }];
    }
    
    
    //上课时间
    if (!IsStrEmpty(listModel.StartTimePad)) {
        self.startTimeLabel.text = listModel.StartTimePad;
    }
    
    //等级
    if (!IsStrEmpty(listModel.LevelName)) {
        self.levelLabel.text = listModel.LevelName;
    }

    //教材名称
    if (!IsStrEmpty(listModel.FileTittle)) {
        self.classNameLabel.text = listModel.FileTittle;
    }


}

@end

