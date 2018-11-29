//
//  GGT_ScheduleUnFinishedCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleUnFinishedCell.h"
#import "GGT_ScheduleStudentIconView.h"

@interface GGT_ScheduleUnFinishedCell()
@property (nonatomic, strong) GGT_ScheduleStudentIconView *iconView; //头像
@end

@implementation GGT_ScheduleUnFinishedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        [self buildUI];
        
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self    selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

// 创建UI
- (void)buildUI {
    // 父view
    self.classBgView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.classBgView];
    
    [self.classBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(LineY(18));
    }];

    
    // 图像
    self.classImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"默认");
        imgView;
    });
    [self.classBgView addSubview:self.classImgView];
    
    [self.classImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView).offset(LineY(14));
        make.left.equalTo(self.classBgView).offset(LineW(14));
        make.bottom.equalTo(self.classBgView).offset(-LineW(14));
        make.width.mas_equalTo(LineW(203));
    }];
    
    
    // 上课时间
    self.classStartTimeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"今日（周一） 12:00";
        label;
    });
    [self.classBgView addSubview:self.classStartTimeLabel];
    
    [self.classStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classImgView.mas_top).offset(-LineY(2));
        make.left.equalTo(self.classImgView.mas_right).offset(margin20);
        make.height.mas_equalTo(LineH(25));
    }];
    
    
    // 课程级别
    self.classLevelLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(42), LineH(24));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(kThemeColor);
        label.backgroundColor = UICOLOR_FROM_HEX_ALPHA(kThemeColor, 10);
//        label.text = @"A2";
        label;
    });
    [self.classBgView addSubview:self.classLevelLabel];
    
    [self.classLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classStartTimeLabel.mas_bottom).offset(LineY(12));
        make.left.equalTo(self.classStartTimeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(LineW(42), LineH(24)));
    }];
    
    
    // 课程标题
    self.classNameLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
//        label.text = @"Lesson1-1";
        label;
    });
    [self.classBgView addSubview:self.classNameLabel];
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classStartTimeLabel.mas_bottom).offset(LineY(12));
        make.left.equalTo(self.classLevelLabel.mas_right).offset(LineX(12));
        make.height.mas_equalTo(LineH(25));
    }];
    
    
    //取消课程
    self.classCancleButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(64), LineH(22));
        xc_button.titleLabel.font = Font(16);
        [xc_button setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
        [xc_button setTitle:@"取消课程" forState:UIControlStateNormal];
        [xc_button setTitle:@"取消课程" forState:UIControlStateHighlighted];
        xc_button;
    });
    [self.classBgView addSubview:self.classCancleButton];
    
    [self.classCancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(17));
        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
        make.height.equalTo(@(self.classCancleButton.height));
    }];
    

    //课前预习
    self.classBeforeButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
        xc_button.titleLabel.font = Font(16);
        xc_button;
    });
    [self.classBgView addSubview:self.classBeforeButton];
    
    
    // 进入教室
    self.classEnterButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(114), LineH(38));
        xc_button.titleLabel.font = Font(16);
        [xc_button setTitle:@"进入教室" forState:UIControlStateNormal];
        xc_button;
    });
    [self.classBgView addSubview:self.classEnterButton];

    [self.classEnterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineH(35));
        make.width.equalTo(@(self.classEnterButton.width));
        make.height.equalTo(@(self.classEnterButton.height));
    }];
    
    
    //即将上课文字
    self.classStatusLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(ColorFF6600);
        //                label.text = @"即将开课：09:12";
        label;
    });
    [self.classBgView addSubview:self.classStatusLabel];
    
    [self.classStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(21));
        make.right.equalTo(self.classBgView.mas_right).offset(-LineX(18));
        make.height.mas_equalTo(LineH(16));
    }];
    
    
    //即将上课图片
    self.classStatusView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        //        imgView.image = UIIMAGE_FROM_NAME(@"沙漏");
        imgView;
    });
    [self.classBgView addSubview:self.classStatusView];
    
    [self.classStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classStatusLabel.mas_bottom);
        make.right.equalTo(self.classStatusLabel.mas_left).offset(-LineX(8.2));
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classEnterButton.mas_left).offset(-LineW(margin10));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineH(35));
        make.width.equalTo(@(self.classBeforeButton.width));
        make.height.equalTo(@(self.classBeforeButton.height));
    }];
    
    
    
    
    //头像View
    self.iconView = [GGT_ScheduleStudentIconView new];
    self.iconView.viewHeight = LineH(56);
    [self.classBgView addSubview:self.iconView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(13));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineH(26));
        make.size.mas_equalTo(CGSizeMake(LineW(386), LineH(56)));
    }];
}


- (void)drawRect:(CGRect)rect {
    [self.classBgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.classImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
    [self.classEnterButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(19)];
    
    [self.classLevelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(12)];
    [self.classLevelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(12)];
}


- (void)getCellModel:(GGT_ScheduleUnFinishedHomeModel *)model {
    if (!IsStrEmpty(model.FilePath)) {
        //请求图片
        [self.classImgView sd_setImageWithURL:[NSURL URLWithString:model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(203), LineW(152))];
            self.classImgView.image = image;
        }];
    }
    
    if (!IsStrEmpty(model.StartTime)) {
        self.classStartTimeLabel.text = model.StartTimePad;
    }
    
    if (!IsStrEmpty(model.LevelName)) {
        self.classLevelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    }
    
    
    
    
    //课程名称     //课程类型 ClassType 0和2都是正课 1:体验课
    switch (model.ClassType) {
        case 0:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.classNameLabel.text = titleStr;
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                }
                self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);

            }
            break;
        case 1:
            self.classNameLabel.text = @"[体验课]";
            self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
            break;
        case 2:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.classNameLabel.text = titleStr;
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                }
                self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);

            }
            break;
        default:
            break;
    }
    
    
    
    //课前预习
    [self classBeforeButtonUI];
    

    //StatusName 0 是未开始  1 上课中 3 即将开始 2 已结束 ----上课时间10分钟之内不可以取消课程
    switch (model.StatusName) {
        case 0: //0 是未开始
            //即将上课文字及图片
            self.classStatusLabel.hidden = YES;
            self.classStatusView.hidden = YES;
            self.classCancleButton.hidden = NO;
            [self enterClassButton:NO];

            break;
        case 1: //1 上课中
            //即将上课文字及图片
            self.classStatusLabel.hidden = NO;
            self.classStatusView.hidden = NO;
            self.classStatusView.image = UIIMAGE_FROM_NAME(@"正在上课1");
            self.classStatusLabel.text = @"正在上课";
            self.classCancleButton.hidden = YES;

            [self enterClassButton:YES];

            break;
        case 2: //2 已结束---无需处理

            break;
        case 3: //3 即将开始
            //即将上课文字及图片
            self.classStatusLabel.hidden = NO;
            self.classStatusView.hidden = NO;
            self.classCancleButton.hidden = YES;

            [self showTimeLabel:model];  //倒计时
            [self enterClassButton:YES];

            break;
        default:
            break;
    }

    
    //给头像传值
    if ([model.StudentList isKindOfClass:[NSArray class]] && model.StudentList.count >0 ) {
        [self.iconView getCellArr:model.StudentList];
    }
}


#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    if (self.countDown == 0) return;
    NSInteger countDown = self.countDown - kCountDownManager.timeInterval;
//    NSLog(@"倒计时：%ld   class:%@",(long)countDown,[self class]);

    if (countDown <=0 || self.countDown <=0) {
        self.countDown = 0;
        self.classStatusView.image = UIIMAGE_FROM_NAME(@"正在上课1");
        self.classStatusLabel.text = @"正在上课";
        
        return;
    } else {
        // 重新赋值
        self.classStatusView.image = UIIMAGE_FROM_NAME(@"沙漏");
        self.classStatusLabel.text = [NSString stringWithFormat:@"即将开课:%02zd:%02zd", (countDown/60)%60, countDown%60];
    }
}



//MARK:倒计时
-(void)showTimeLabel:(GGT_ScheduleUnFinishedHomeModel *)model {
    //获取上课时间
    NSString *LessonTimeStr = model.StartTime;
    if (LessonTimeStr.length == 16) {
        LessonTimeStr = [NSString stringWithFormat:@"%@:00",model.StartTime];
    }
    
    //获取时间差
    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    NSTimeInterval timeCount = [sin pleaseInsertStarTime:sin.nowDateString andInsertEndTime:LessonTimeStr class:@"GGT_ScheduleUnFinishedCell"];
    self.countDown = timeCount;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
