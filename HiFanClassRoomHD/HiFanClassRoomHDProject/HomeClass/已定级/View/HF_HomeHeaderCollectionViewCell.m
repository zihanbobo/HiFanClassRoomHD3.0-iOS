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
@property (nonatomic,strong) UIButton *cellRightButton;
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
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
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
    self.bookImgView.image = UIIMAGE_FROM_NAME(@"缺省图165-165");
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
    self.levelLabel.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0x67D3CE, 20);
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
//     self.monthOrWeekLabel.text = @"10月29日 周三";
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
    [self.classBeforeButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:UIControlStateNormal];
    [self.classBeforeButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
    [self.classBeforeButton setTitle:@"课前预习" forState:UIControlStateNormal];
    self.classBeforeButton.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(16)];
    [self.bigContentView addSubview:self.classBeforeButton];
    
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImgView.mas_right).offset(17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-17);
        make.size.mas_equalTo(CGSizeMake(135, 40));
    }];
    
    @weakify(self);
    [[self.classBeforeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.classBeforeBtnBlock) {
             self.classBeforeBtnBlock();
         }
     }];
    
    //课后练习
    self.cellRightButton = [UIButton new];
    self.cellRightButton.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(16)];
    [self.bigContentView addSubview:self.cellRightButton];
    
    
    [self.cellRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bigContentView.mas_right).offset(-17);
        make.bottom.equalTo(self.bigContentView.mas_bottom).offset(-17);
        make.size.mas_equalTo(CGSizeMake(135, 40));
    }];
    
    [[self.cellRightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.cellRightButtonBlock) {
             self.cellRightButtonBlock(self.cellRightButton);
         }
     }];
}


- (void)setCellModel:(HF_HomeHeaderModel *)cellModel {
    if (!IsStrEmpty(cellModel.ChapterImagePath)) {
        [self.bookImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.ChapterImagePath] placeholderImage:UIIMAGE_FROM_NAME(@"缺省图165-165")];
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
    
     //0 是未开始  1 上课中 2 即将开始 3 已结束
    switch (cellModel.StatusName) {
        case 0:
            self.monthOrWeekLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
            [self.cellRightButton setTitle:@"进入教室" forState:(UIControlStateNormal)];
            [self.cellRightButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
            [self.cellRightButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:UIControlStateNormal];

            break;
        case 1:
            self.monthOrWeekLabel.text = @"正在上课";
            self.monthOrWeekLabel.textColor = UICOLOR_FROM_HEX(0xFF8A65);
            [self.cellRightButton setTitle:@"进入教室" forState:(UIControlStateNormal)];
            [self.cellRightButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterClassBtn") forState:UIControlStateNormal];
            [self.cellRightButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
            
            break;
        case 2:
            NSLog(@"111111");
            [self showTimeLabel:cellModel];
            [self.cellRightButton setTitle:@"进入教室" forState:(UIControlStateNormal)];
            [self.cellRightButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterClassBtn") forState:UIControlStateNormal];
            [self.cellRightButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
            
            break;
        case 3:
            self.monthOrWeekLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
            [self.cellRightButton setTitle:@"课后练习" forState:(UIControlStateNormal)];
            [self.cellRightButton setBackgroundImage:UIIMAGE_FROM_NAME(@"classBeforeBtn") forState:UIControlStateNormal];
            [self.cellRightButton setTitleColor:UICOLOR_FROM_HEX(Color02B6E3) forState:UIControlStateNormal];
            
            break;
        default:
            break;
    }
}


#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    if (self.countDown == 0) return;
    NSInteger countDown = self.countDown - kCountDownManager.timeInterval;

    if (countDown <=0 || self.countDown <=0) {
        self.countDown = 0;
        self.monthOrWeekLabel.text = @"正在上课";
        self.monthOrWeekLabel.textColor = UICOLOR_FROM_HEX(0xFF8A65);
        return;
    } else {
        // 重新赋值
        self.monthOrWeekLabel.text = [NSString stringWithFormat:@"即将开课:%02zd:%02zd", (countDown/60)%60, countDown%60];
        self.monthOrWeekLabel.textColor = UICOLOR_FROM_HEX(0xFF8A65);
    }
}

//MARK:倒计时
-(void)showTimeLabel:(HF_HomeHeaderModel *)model {
    //获取上课时间
    NSString *LessonTimeStr = model.LessonTime;
    LessonTimeStr = [LessonTimeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "]; //替换字符
    
    //获取时间差
    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    NSTimeInterval timeCount = [sin pleaseInsertStarTime:sin.nowDateString andInsertEndTime:LessonTimeStr class:@"HF_HomeHeaderCollectionViewCell"];
    self.countDown = timeCount;
}


- (void)drawRect:(CGRect)rect {
    [self.bookImgView xc_SetCornerWithSideType:XCSideTypeLeftLine cornerRadius:7];
    [self.bigContentView addBorderForViewWithBorderWidth:0.01 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:7];
    [self.bigContentView addShadowForViewWithShadowOffset:CGSizeMake(0, 0) ShadowOpacity:1 ShadowRadius:7 ShadowColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 12)];

    [self.levelLabel addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(Color67D3CE) CornerRadius:9];
    [self.levelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:9];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
