//
//  GGT_ScheduleUnFisishedHeaderInfoCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleUnFisishedHeaderInfoCell.h"

@interface GGT_ScheduleUnFisishedHeaderInfoCell()
@end

@implementation GGT_ScheduleUnFisishedHeaderInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self    selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
        
    }
    return self;
}

// 创建UI
- (void)buildUI {
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
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
    
    
    //封面
    self.classImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"默认");
        imgView;
    });
    [self.classBgView addSubview:self.classImgView];
    
    [self.classImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView).offset(LineY(14));
        make.left.equalTo(self.classBgView).offset(LineX(14));
        make.bottom.equalTo(self.classBgView).offset(-LineY(14));
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
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(margin20));
        make.height.mas_equalTo(LineH(25));
    }];
    
    
    //即将上课文字
    self.classStatusLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(ColorFF6600);
        //        label.text = @"即将开课：09:12";
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
        imgView.image = UIIMAGE_FROM_NAME(@"正在上课1");
        imgView;
    });
    [self.classBgView addSubview:self.classStatusView];
    
    [self.classStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classStatusLabel.mas_bottom);
        make.right.equalTo(self.classStatusLabel.mas_left).offset(-LineX(8.2));
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    
    // 邀请好友
//    self.yaoqingButton = ({
//        UIButton *xc_button = [UIButton new];
//        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
//        xc_button.titleLabel.font = Font(16);
//        [xc_button setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
//        [xc_button setTitle:@"邀请好友" forState:UIControlStateNormal];
//        [xc_button setTitle:@"邀请好友" forState:UIControlStateHighlighted];
//        xc_button.backgroundColor = UICOLOR_FROM_HEX(ColorFF6600);
//        xc_button;
//    });
//    [self.classBgView addSubview:self.yaoqingButton];
//    self.yaoqingButton.hidden = YES;
//
//    [self.yaoqingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.classBgView.mas_top).offset(LineY(14));
//        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
//        make.size.mas_equalTo(CGSizeMake(LineW(108), LineH(36)));
//    }];
    
    
    //取消课程
    //    self.xc_cancleClassButton = ({
    //        UIButton *xc_button = [UIButton new];
    //        xc_button.frame = CGRectMake(0, 0, LineW(64), LineH(22));
    //        xc_button.titleLabel.font = Font(16);
    //        [xc_button setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
    //        [xc_button setTitle:@"取消课程" forState:UIControlStateNormal];
    //        [xc_button setTitle:@"取消课程" forState:UIControlStateHighlighted];
    //        xc_button;
    //    });
    //    [self.classBgView addSubview:self.xc_cancleClassButton];
    //
    //    [self.xc_cancleClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.classBgView.mas_top).offset(LineY(17));
    //        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
    //        make.height.mas_equalTo(LineH(22));
    //    }];
    
    
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
        make.top.equalTo(self.classStartTimeLabel.mas_bottom).offset(LineY(16));
        make.left.equalTo(self.classStartTimeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(LineW(42), LineH(24)));
    }];
    
    //课程名称
    self.classNameLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(70), LineH(25));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(18);
        //        label.text = @"[体验课]";
        label;
    });
    [self.classBgView addSubview:self.classNameLabel];
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classLevelLabel);
        make.left.equalTo(self.classLevelLabel.mas_right).offset(LineX(12));
        make.height.mas_equalTo(LineH(25));
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
        make.right.equalTo(self.classBgView.mas_right).offset(-LineX(18));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineH(35));
        make.size.mas_equalTo(CGSizeMake(LineW(114), LineH(38)));
        
    }];
    
    
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classEnterButton.mas_left).offset(-LineW(margin10));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineH(35));
        make.size.mas_equalTo(CGSizeMake(LineW(108), LineH(36)));
        
    }];
    
    
    //课程介绍
    self.classInfoLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(70), LineH(25));
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
        //        label.text = @"to introduce vocabulary about foodschocolate, coo pizza, sandwich, hamburger, French frieamburger, French fries";
        label;
    });
    [self.classBgView addSubview:self.classInfoLabel];
    
    [self.classInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classLevelLabel.mas_bottom).offset(LineY(12));
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(12.7));
        make.right.equalTo(self.classBeforeButton.mas_left).offset(-LineW(28));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(13));
    }];
    
}


- (void)drawRect:(CGRect)rect {
    [self.classBgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.classImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
    [self.classEnterButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(19)];
//    [self.yaoqingButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(18)];
    
    
    [self.classLevelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(12)];
    [self.classLevelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(12)];
}

- (void)getCellModel :(GGT_ScheduleDetailModel *)model {
    if (!IsStrEmpty(model.FilePath)) {
        //请求图片
        [self.classImgView sd_setImageWithURL:[NSURL URLWithString:model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(203), LineW(152))];
            self.classImgView.image = image;
        }];
    }
    
    
    //开课时间
    if (!IsStrEmpty(model.StartTime)) {
        self.classStartTimeLabel.text = model.StartTimePad;
    }
    
    //级别
    if (!IsStrEmpty(model.LevelName)) {
        self.classLevelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    }
    
    
    //课程名称     //课程类型 ClassType 0和2正课 1:体验课
    switch (model.ClassType) {
            case 0:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.classNameLabel.text = titleStr;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                    
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                }
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
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                    
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                }
            }
            break;
        default:
            break;
    }
    
    
    
    //课程介绍
    if (!IsStrEmpty(model.Describe)) {
        self.classInfoLabel.text = model.Describe;
    }
    
    
    //课前预习
    [self classBeforeButtonUI];

    
    //0 是未开始  1 上课中 3 即将开始 2 已结束 ----上课时间10分钟之内不可以取消课程
    switch (model.StatusName) {
        case 0:
            self.classStatusView.hidden = YES;
            self.classStatusLabel.hidden = YES;
            
            [self enterClassButton:NO];
//            self.yaoqingButton.hidden = NO;
            break;
        case 1:
            [self enterClassButton:YES];
            self.classStatusView.hidden = NO;
            self.classStatusLabel.hidden = NO;
            self.classStatusView.image = UIIMAGE_FROM_NAME(@"正在上课1");
            self.classStatusLabel.text = @"正在上课";
//            self.yaoqingButton.hidden = YES;
            break;
        case 2: //已结束
            [self enterClassButton:NO];
//            self.yaoqingButton.hidden = YES;

            break;
        case 3:
            [self enterClassButton:YES];
//            self.yaoqingButton.hidden = YES;
            [self showTimeLabel:model];
             //即将上课文字及图片
            self.classStatusLabel.hidden = NO;
            self.classStatusView.hidden = NO;
            break;
        default:
            break;
    }
}


#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    NSInteger countDown = self.countDown - kCountDownManager.timeInterval;
//    NSLog(@"倒计时：%ld   class:%@",(long)countDown,[self class]);

    if (countDown <=0 || self.countDown <=0) {
        self.countDown = 0;

        self.classStatusView.image = UIIMAGE_FROM_NAME(@"正在上课1");
        self.classStatusLabel.text = @"正在上课";
        
        return;
    } if (countDown >0 && countDown <= 600) {
        // 重新赋值
        self.classStatusView.image = UIIMAGE_FROM_NAME(@"沙漏");
        self.classStatusLabel.text = [NSString stringWithFormat:@"即将开课:%02zd:%02zd", (countDown/60)%60, countDown%60];

    } else if (countDown >0 && countDown > 600) {
        //MARK:程序上来说，不会走这里
        [self enterClassButton:NO];
        self.classStatusLabel.hidden = YES;
        self.classStatusView.hidden = YES;
    }
}


//MARK:倒计时
-(void)showTimeLabel:(GGT_ScheduleDetailModel *)model {
    //对后台请求的数据进行处理，如果没有带秒。添加上
    if (model.StartTime.length == 16) {
        model.StartTime = [NSString stringWithFormat:@"%@:00",model.StartTime];
    }
    
    //获取时间差
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    NSTimeInterval timeCount = [sin pleaseInsertStarTime:sin.nowDateString andInsertEndTime:model.StartTime class:@"GGT_ScheduleUnFisishedHeaderInfoCell"];
    self.countDown = timeCount;
}


@end

