//
//  HF_HomeHeaderCollectionViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeHeaderCollectionViewCell.h"

@interface HF_HomeHeaderCollectionViewCell()
//背景
@property (nonatomic, strong) UIView *bigContentView;
//教材 封面
@property (nonatomic, strong) UIImageView *bookImgView;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
//上课时间 XX:XX
@property (nonatomic, strong) UILabel *timeSpanLabel;
//上课时间 MonthOrWeek
@property (nonatomic, strong) UILabel *monthOrWeekLabel;
//等级
@property (nonatomic, strong) UILabel *levelLabel;
/**
 所上课程-课前预习
 */
@property (nonatomic,strong) UIButton *classBeforeButton;
/**
 所上课程-课后练习
 */
@property (nonatomic,strong) UIButton *classAfterButton;
/**
 所上课程-进入教室
 */
@property (nonatomic,strong) UIButton *classEnterButton;
@end

@implementation HF_HomeHeaderCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
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
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];
    
    
    //教材 封面
    self.bookImgView = [[UIImageView alloc]init];
    self.bookImgView.image = UIIMAGE_FROM_NAME(@"默认");
    self.bookImgView.userInteractionEnabled = YES;
    [self.bigContentView addSubview:self.bookImgView];

    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).with.offset(0);
        make.left.equalTo(self.bigContentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(159, 159));
    }];


    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
//    self.classNameLabel.text = @"Lesson2-1";
    self.classNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(18)];
    self.classNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self.bigContentView addSubview:self.classNameLabel];


    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).offset(25);
        make.left.equalTo(self.bookImgView.mas_right).offset(17);
        make.height.mas_equalTo(18);
    }];

    //等级
    self.levelLabel = [[UILabel alloc]init];
//    self.levelLabel.text = @"A1";
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(12)];
    self.levelLabel.textColor = UICOLOR_FROM_HEX(Color02B6E3);
    [self.bigContentView addSubview:self.levelLabel];
    
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classNameLabel.mas_bottom).offset(6);
        make.left.equalTo(self.bookImgView.mas_right).offset(17);
        make.size.mas_equalTo(CGSizeMake(35, 18));
    }];


    //上课时间
    self.timeSpanLabel = [[UILabel alloc]init];
    self.timeSpanLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(26)];
//    self.timeSpanLabel.text = @"20:00";
    self.timeSpanLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self.bigContentView addSubview:self.timeSpanLabel];


    [self.timeSpanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).offset(17);
        make.right.equalTo(self.bigContentView.mas_right).offset(-17);
        make.height.mas_equalTo(26);
    }];
    
    
    //上课时间 MonthOrWeek
    self.monthOrWeekLabel = [[UILabel alloc]init];
    self.monthOrWeekLabel.font = Font(14);
//     self.monthOrWeekLabel.text = @"20:00";
    self.monthOrWeekLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    [self.bigContentView addSubview:self.monthOrWeekLabel];
    
    
    [self.monthOrWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeSpanLabel.mas_bottom).offset(10);
        make.right.equalTo(self.bigContentView.mas_right).offset(-17);
        make.height.mas_equalTo(14);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.bigContentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigContentView.mas_top).offset(84);
        make.left.equalTo(self.bookImgView.mas_right).with.offset(17);
        make.right.equalTo(self.bigContentView.mas_right).with.offset(-17);
        make.height.mas_equalTo(1);
    }];
    
    
    //课前预习
    self.classBeforeButton = [UIButton new];
    [self.classBeforeButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:(UIControlStateNormal)];
    [self.classBeforeButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
    [self.classBeforeButton setTitle:@"课前预习" forState:(UIControlStateNormal)];
    self.classBeforeButton.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(16)];
    [self.bigContentView addSubview:self.classBeforeButton];
    
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImgView.mas_right).offset(17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-17);
        make.size.mas_equalTo(CGSizeMake(135, 40));
    }];
    
    
    //课后复习
    self.classAfterButton = [UIButton new];
    self.classAfterButton.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(16)];
    [self.classAfterButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:(UIControlStateNormal)];
    [self.classAfterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
    [self.classAfterButton setTitle:@"课后复习" forState:(UIControlStateNormal)];
    [self.bigContentView addSubview:self.classAfterButton];
    
    
    [self.classAfterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bigContentView.mas_right).offset(-17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-17);
        make.size.mas_equalTo(CGSizeMake(135, 42));
    }];
    
}


- (void)drawRect:(CGRect)rect {
    [self.bookImgView xc_SetCornerWithSideType:XCSideTypeLeftLine cornerRadius:7];
    [self.bigContentView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
    [self.bigContentView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];
    [self.levelLabel addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(Color67D3CE) CornerRadius:9];
}

- (void)setCellModel:(HF_HomeHeaderModel *)cellModel {
    if (!IsStrEmpty(cellModel.ChapterImagePath)) {
        [self.bookImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.ChapterImagePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

            image = [image imageScaledToSize:CGSizeMake(LineW(230), LineW(180))];
            self.bookImgView.image = image;
        }];
    }
    
    
    if (!IsStrEmpty(cellModel.ChapterName)) {
        self.classNameLabel.text = cellModel.ChapterName;
    }
    
    if (!IsStrEmpty(cellModel.TimeSpan)) {
        self.timeSpanLabel.text = cellModel.TimeSpan;
    }
    
    if (!IsStrEmpty(cellModel.LevelName)) {
        self.levelLabel.text = cellModel.LevelName;
    }

    if (!IsStrEmpty(cellModel.MonthOrWeek)) {
        self.monthOrWeekLabel.text = cellModel.MonthOrWeek;
    }
    

    
}


@end
